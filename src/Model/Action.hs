{-# LANGUAGE RankNTypes #-}

module Model.Action
  (Action, ActionType(..), setText, unwrapAction) where

import Control.Monad.IO.Class (liftIO)

import Model.Execute (Execute)

data Action = forall a. Action (a -> IO ()) (ActionType a)

data ActionType a where
  SetText :: String -> ActionType ()

unwrapAction :: (forall a. ActionType a -> Execute a) -> Action -> Execute ()
unwrapAction handle (Action feedBack actionType) = handle actionType >>= liftIO . feedBack

setText :: String -> (() -> IO ()) -> Action
setText s f = Action f $ SetText s
