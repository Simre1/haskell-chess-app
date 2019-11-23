module Model.Setup where


import Control.Concurrent.Async (async, link)
import Control.Concurrent.Chan.Unagi (newChan, writeChan, readChan)
import Control.Monad (forever)
import Data.IORef (newIORef, IORef, readIORef)

import Model.Action (Action)
import Model.ActionHandler (handleAction)
import Model.Execute (runExecute)
import Model.ModelState (configureModel, initialiseModelState, ModelState)


setupModel :: (ModelState -> IO ()) -> IO (Action -> IO ())
setupModel feedBridge = do
  initialModelState <- initialiseModelState configureModel
  modelState <- newIORef initialModelState

  (inChan, outChan) <- newChan
  asyncThread <- async $ forever $
    readChan outChan >>= flip runExecute modelState . handleAction >> readIORef modelState >>= feedBridge
  link asyncThread
  readIORef modelState >>= feedBridge

  pure $ (writeChan inChan)
