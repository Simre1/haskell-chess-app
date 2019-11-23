module Interface.ExternalInput
  (ExternalInput(..)) where

import Interface.InterfaceState (InterfaceState)

data ExternalInput = ExternalInput (IO (InterfaceState -> InterfaceState))
