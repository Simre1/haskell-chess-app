module Interface.Setup where

import Control.Monad.IO.Class (liftIO)
import qualified GI.Gtk.Declarative.App.Simple as GTKD
import qualified GI.Gtk.Declarative as GTKD
import qualified GI.Gtk as GTK
import Pipes (yield)


import Interface.ExternalInput (ExternalInput(..))
import Interface.InterfaceState (initialiseInterfaceState, InterfaceState, configureInterface)
import Interface.InterfaceEvent (InterfaceEvent(..))
import Interface.View (view)
import Interface.Update (update)



setupInterface :: (ExternalInput, InterfaceEvent -> IO ()) -> IO ()
setupInterface (externalInput, bridgeEvent) = do
  initialInterfaceState <- initialiseInterfaceState configureInterface
  GTKD.run GTKD.App
    { GTKD.view         = view
    , GTKD.update       = update bridgeEvent
    , GTKD.inputs       = [toInput externalInput]
    , GTKD.initialState = initialInterfaceState
    }
  pure ()
  where
    toInput (ExternalInput modifyInterface) = do
      f <- liftIO modifyInterface
      yield $ ModifyInterface f
      toInput (ExternalInput modifyInterface)
