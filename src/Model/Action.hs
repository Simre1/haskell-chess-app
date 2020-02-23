module Model.Action where

import Model.State

import Data.Text (Text)

import Game.Chess

data GameSource = New deriving Show

data GameTabAction
  = LoadGame
  | SelectField (Int, Int)
  | PlayMove (Int, Int) (Int, Int)
  | PromotePawn (Int, Int) (Int, Int) PieceType
  deriving Show

data Action
  = CheckAlive
  | CloseApp
  | AddGameTab GameSource
  | GameTabAction TabId GameTabAction
  deriving Show
