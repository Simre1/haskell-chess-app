module Model.Handler where

import Model.Effect (Effect, closeApp, getState, modifyState, modifyStateM, scheduleAction, logDebug)
import Model.Action
import Model.State
import Model.Handler.Tab
import Model.Handler.Utils
import Optics.Core
import qualified Data.Map as M

import Game.Chess

import Control.Effectful


import Debug.Trace

handle :: Action -> Effectful Effect ()
handle action = case action of
  CheckAlive -> pure $ ()
  CloseApp -> closeApp
  AddGameTab _ -> do
    id' <- generateId
    let newTab = Tab "New Game" ChessBoard [] $ GameTabS $ GameTab Nothing $
          Game startpos Nothing Nothing Nothing Nothing Nothing Undecided
    modifyState $ over gameTabs $ M.insert id' newTab
  GameTabAction tabId' tabAction -> handleGameTabAction tabId' tabAction
  _ -> error "I don't know what to do!"
