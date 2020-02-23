module Model.Handler.Tab where

import Control.Effectful

import Optics.Core
import qualified Data.Map as M

import Data.Maybe
import Game.Chess

import Model.Effect
import Model.State
import Model.Action

handleGameTabAction :: TabId -> GameTabAction -> Effectful Effect ()
handleGameTabAction tabId' tabAction = withGameTab tabId' $ \tab -> case tabAction of
  SelectField (row, column) -> do
    case (view (concreteTab % selectedField) tab) of
      Nothing -> do
        case pieceAt (view (concreteTab % game % position) tab) (row * 8 + column) of
          Nothing -> pure tab
          (Just _) -> pure $ set (concreteTab % selectedField) (pure (row, column)) tab
      Just oldSelected -> do
        scheduleAction (GameTabAction tabId' $ PlayMove oldSelected (row, column))
        pure $ set (concreteTab % selectedField) Nothing tab
  PlayMove from@(rowF, columnF) to@(rowT,columnT) -> do
    if (rowT == 0 || rowT == 7) && Just Pawn == (snd <$> pieceAt (view (concreteTab % game % position) tab) (rowF * 8 + columnF))
      then scheduleAction (GameTabAction tabId' $ PromotePawn from to Queen) *> pure tab
      else tryExecutingPly tab from to Nothing
  PromotePawn from to pieceType -> tryExecutingPly tab from to (Just pieceType)
  _ -> error "I don't know what to do!"

tryExecutingPly :: (Tab GameTab) -> (Int, Int) -> (Int, Int) -> Maybe PieceType -> Effectful Effect (Tab GameTab)
tryExecutingPly tab from to@(row, column) promote = case fromUCI (tab ^. concreteTab % game % position) uciString of
  Nothing -> do
    if isJust (pieceAt (tab ^. concreteTab % game % position) (row * 8 + column))
      then pure $ set (concreteTab % selectedField) (Just to) tab
      else pure tab

  (Just ply) -> pure $ over (concreteTab % game % position) (flip doPly ply) tab
  where uciString = toField from <> toField to <> promoteToString promote
        promoteToString (Just Queen) = "q"
        promoteToString (Just Knight) = "k"
        promoteToString (Just Rook) = "r"
        promoteToString (Just Bishop) = "b"
        promoteToString _ = ""
        toField (r,c) =
          case c of
            0 -> "a"
            1 -> "b"
            2 -> "c"
            3 -> "d"
            4 -> "e"
            5 -> "f"
            6 -> "g"
            7 -> "h"
           ++ show (succ r)

withGameTab :: TabId -> (Tab GameTab -> Effectful Effect (Tab GameTab)) -> Effectful Effect ()
withGameTab tabId' f = do
  modifyStateM $ \state -> do
    alteredTabs <- M.alterF (traverse f) tabId' $ view gameTabs state
    pure $ set gameTabs alteredTabs state
