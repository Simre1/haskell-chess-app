module Model.Effect where

import Data.Unique

import Model.State (State)
import Model.Action (Action)

import Control.Effectful

data Effect a where
  GetState :: Effect State
  PutState :: State -> Effect ()
  ScheduleAction :: Action -> Effect ()
  LogDebug :: String -> Effect ()
  CloseApp :: Effect ()

getState :: Effectful Effect State
getState = runEffect GetState

putState :: State -> Effectful Effect ()
putState state = runEffect (PutState state)

modifyState :: (State -> State) -> Effectful Effect ()
modifyState f = (f <$> getState) >>= putState

modifyStateM :: (State -> Effectful Effect State) -> Effectful Effect ()
modifyStateM f = getState >>= f >>= putState

scheduleAction :: Action -> Effectful Effect ()
scheduleAction = runEffect . ScheduleAction

closeApp :: Effectful Effect ()
closeApp = runEffect CloseApp

logDebug :: Show a => a -> Effectful Effect ()
logDebug = runEffect . LogDebug . show
