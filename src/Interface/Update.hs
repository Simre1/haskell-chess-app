module Interface.Update
  (update) where

import GI.Gtk.Declarative.App.Simple (Transition(..))

import Interface.InterfaceState (InterfaceState)
import Interface.InterfaceEvent (InterfaceEvent(..))


update :: (InterfaceEvent -> IO ()) -> InterfaceState -> InterfaceEvent -> Transition InterfaceState InterfaceEvent
update bridgeEvent state event = case update' state event of
  Transition s a -> Transition s (bridgeEvent event *> a)
  Exit -> Exit


update' :: InterfaceState -> InterfaceEvent -> Transition InterfaceState InterfaceEvent
update' state event = case event of
  (ModifyInterface f) -> Transition (f state) (pure Nothing)
  _ -> Transition state (pure Nothing)
