module Model.InitializeState where

import Model.State
import Data.Unique

import Game.Chess

data Configuration = Configuration

initializeState :: Configuration -> IO State
initializeState _ =
  pure $ State [] 0
