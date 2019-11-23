module Model.ActionHandler (handleAction) where

import Optics.Core ((.~), view)


import Model.Action (Action, ActionType(..), unwrapAction)
import Model.Execute (Execute, asks, modify)
import Model.ModelState (helloWorld)

handleAction :: Action -> Execute ()
handleAction = unwrapAction $ \actionType -> case actionType of
  (SetText s) -> modify (helloWorld .~ s)
