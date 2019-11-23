module Bridge.EventActions
  (mapEventToActions) where

import Data.Coerce (coerce)

import Interface.InterfaceEvent (InterfaceEvent(..))
import Model.Action (ActionType(..), Action, setText)

mapEventToActions :: InterfaceEvent -> Maybe Action
mapEventToActions event = case event of
  ForGlory -> pure $ setText "For Glory!" pure
  _ -> Nothing
