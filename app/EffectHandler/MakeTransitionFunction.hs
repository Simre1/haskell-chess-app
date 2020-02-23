module EffectHandler.MakeTransitionFunction where

import Control.Monad (forM_, join)
import Data.Functor (($>))
import Data.Functor.Identity
import GI.Gtk.Declarative.App.Simple
import Control.Concurrent

import EffectHandler.EffectHandler

import Model.Effect
import Model.State
import Model.Action
import Control.Concurrent.Chan

setUpTransitionFunction :: IO (EffectHandler Identity () -> State -> Transition State Action, IO Action, IO ())
setUpTransitionFunction = do
  workChan <- newChan
  actionChan <- newChan
  tId <- forkIO $
    let loop = do
          maybeAction <- join (readChan workChan)
          case maybeAction of
            Nothing -> pure ()
            Just action -> writeChan actionChan action
          loop
    in loop
  pure $ (makeTransition (\a -> writeChan workChan a), readChan actionChan, killThread tId)

makeTransition :: (IO (Maybe Action) -> IO ()) -> EffectHandler Identity () -> State -> Transition State Action
makeTransition feedAction effectHandler state = runIdentity $ do
  (newState, asyncActions, shouldClose, _) <- runEffectHandler effectHandler state
  if shouldClose
    then pure Exit
    else pure $ Transition newState (forM_ asyncActions feedAction $> Nothing)
