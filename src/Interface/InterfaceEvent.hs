module Interface.InterfaceEvent
  (InterfaceEvent(..)) where

import Interface.InterfaceState (InterfaceState)

data InterfaceEvent
  = ModifyInterface (InterfaceState -> InterfaceState)
  | ForGlory
