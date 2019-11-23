module Bridge.Setup (setupBridge) where


import Control.Concurrent.MVar (MVar, newEmptyMVar, takeMVar, putMVar, tryTakeMVar)
import Data.IORef (readIORef, IORef)
import Data.Maybe (maybe)



import Bridge.EventActions (mapEventToActions)
import Bridge.State (mapState)
import Interface.ExternalInput (ExternalInput(..))
import Interface.InterfaceEvent (InterfaceEvent)
import Model.Action (Action)
import Model.ModelState (ModelState)

setupBridge :: IO ((Action -> IO ()) -> (ExternalInput, InterfaceEvent -> IO ()), ModelState -> IO ())
setupBridge = do
  mvar <- newEmptyMVar
  pure ( \feedModel -> ( ExternalInput (mapState <$> takeMVar mvar)
         , maybe (pure ()) feedModel . mapEventToActions
         )
       , \modelState -> tryTakeMVar mvar >> putMVar mvar modelState
       )
