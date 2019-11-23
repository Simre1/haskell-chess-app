module Main where

import Bridge.Setup (setupBridge)
import Interface.Setup (setupInterface)
import Model.Setup (setupModel)

main :: IO ()
main = do
  (interfaceBridge, modelBridge) <- setupBridge
  feedModel <- setupModel modelBridge
  setupInterface (interfaceBridge feedModel)
