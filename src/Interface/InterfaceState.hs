{-# LANGUAGE TemplateHaskell #-}

module Interface.InterfaceState
  ( InterfaceConfig
  , InterfaceState
  , initialiseInterfaceState
  , configureInterface
  , interfaceText
  ) where

import Data.Text (Text)

import Optics.TH (makeLenses)

data InterfaceConfig = InterfaceConfig

data InterfaceState = InterfaceState
  { _interfaceText :: Text
  } deriving (Show)

makeLenses ''InterfaceState

initialiseInterfaceState :: InterfaceConfig -> IO InterfaceState
initialiseInterfaceState config = pure $ InterfaceState "Hello World"

configureInterface :: InterfaceConfig
configureInterface = InterfaceConfig
