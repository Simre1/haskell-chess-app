module View.Panel.ChessBoard where

import GI.Gtk.Declarative
import GI.Gtk.Declarative.Container.Grid
import GI.Gtk (Grid(..), Label(..), Button(..))

import Data.Vector

import Game.Chess
import Data.Text (Text)

import Model.State
import Model.Action

showChessBoard :: TabId -> Maybe (Int, Int) -> Position -> Widget Action
showChessBoard tabId' selected position =
  container
          Grid
          [#rowSpacing := 8, #columnSpacing := 8, #margin := 0] $
          flip fmap piecePositions $ \((t,l), square) ->
            let selectedClass = case selected of
                  Nothing -> ""
                  Just (r,c) -> if r == t && c == l
                    then "chess-field-selected"
                    else ""
            in GridChild defaultGridChildProperties {leftAttach=toEnum l, topAttach=toEnum t} $
              case square of
                Nothing -> widget Button
                  [ #label := ""
                  , #expand := True
                  , on #clicked $ GameTabAction tabId' $ SelectField (t,l)
                  , classes ["chess-field", selectedClass]
                  ]
                Just (color, pieceType) -> widget Button
                  [#label := pieceToText pieceType
                  , #expand := True
                  , on #clicked $ GameTabAction tabId' $ SelectField (t,l)
                  , classes [colorToText color, "chess-field", selectedClass]
                  ]
  where
    piecePositions :: Vector ((Int, Int), Maybe (Color, PieceType))
    piecePositions = (\i -> (toRF i, pieceAt position i)) <$> ([0..63] :: Vector Int)
    pieceToText :: PieceType -> Text
    pieceToText pieceType = case pieceType of
      King -> "K!"
      Queen -> "Q"
      Bishop -> "B"
      Knight -> "K"
      Rook -> "R"
      Pawn -> "P"
    colorToText :: Color -> Text
    colorToText White = "white-piece"
    colorToText Black = "black-piece"
