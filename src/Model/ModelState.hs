{-# LANGUAGE TemplateHaskell #-}

module Model.ModelState
  ( ModelState
  , configureModel
  , initialiseModelState
  , helloWorld
  ) where

import Optics.TH (makeLenses)

data ModelConfig = ModelConfig

configureModel :: ModelConfig
configureModel = ModelConfig

initialiseModelState :: ModelConfig -> IO ModelState
initialiseModelState config = pure $ ModelState "Hello"

data ModelState = ModelState
  { _helloWorld :: String
  }

makeLenses ''ModelState
