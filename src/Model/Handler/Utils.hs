module Model.Handler.Utils where

import Control.Effectful
import Optics.Core

import Model.Effect
import Model.State

generateId :: Effectful Effect Int
generateId = do
  id' <- view incrementId <$> getState
  modifyState $ over incrementId succ
  pure id'
