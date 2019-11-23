module Model.Execute
  ( Execute
  , asks
  , modify
  , atomicModify
  , runExecute
  ) where

import Control.Monad.IO.Class (liftIO, MonadIO)

import Data.IORef (IORef, readIORef, modifyIORef, atomicModifyIORef)

import Model.ModelState (ModelState)

newtype Execute a = Execute {runExecute :: IORef ModelState -> IO a}

instance Functor Execute where
  fmap f (Execute operation) = Execute $ \modelState -> f <$> operation modelState

instance Applicative Execute where
  pure a = Execute . const $ pure a
  (Execute f) <*> (Execute a) = Execute $ \modelState -> f modelState <*> a modelState

instance Monad Execute where
  (Execute a) >>= f = Execute $ \modelState -> do
    a modelState >>= flip runExecute modelState . f

asks :: (ModelState -> a) -> Execute a
asks f = Execute $ \modelState -> f <$> readIORef modelState

modify :: (ModelState -> ModelState) -> Execute ()
modify f = Execute $ \modelState -> modifyIORef modelState f

atomicModify :: (ModelState -> (ModelState, a)) -> Execute a
atomicModify f = Execute $ \modelState -> atomicModifyIORef modelState f

instance MonadIO Execute where
  liftIO action = Execute $ \_ -> action
