module Bridge.State where

import Optics.Core ((.~), (^.), (&))
import Data.Text (pack, unpack)

import Interface.InterfaceState (InterfaceState, interfaceText)
import Model.ModelState (ModelState, helloWorld)

mapState :: ModelState -> InterfaceState -> InterfaceState
mapState modelState currentState = currentState & interfaceText .~ (pack $ modelState ^. helloWorld)
