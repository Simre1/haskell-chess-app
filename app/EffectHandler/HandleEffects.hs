module EffectHandler.HandleEffects where

import Data.Functor.Identity

import Data.Functor (($>))

import Control.Effectful
import EffectHandler.EffectHandler
import Model.Effect (Effect(..))

import Debug.Trace

handleEffects :: Effectful Effect () -> EffectHandler Identity ()
handleEffects computation =
  runEffectful handleEffect computation

handleEffect :: Effect a -> EffectHandler Identity a
handleEffect effect = case effect of
  GetState -> getState
  PutState state -> putState state
  CloseApp -> closeApp
  ScheduleAction action -> spawnAsyncAction (pure $ pure action)
  LogDebug str -> spawnAsyncAction (print str $> Nothing)
  _ -> error "I don't know how to handle this effect!"
