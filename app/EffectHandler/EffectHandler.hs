module EffectHandler.EffectHandler where

import Model.State
import Model.Action

data EffectHandler m a = EffectHandler {runEffectHandler :: State -> m (State, [IO (Maybe Action)], Bool, a)}

instance Functor m => Functor (EffectHandler m) where
  fmap f (EffectHandler run) = EffectHandler $ fmap change . run
    where change (a,b,c,d) = (a,b,c,f d)

instance Monad m => Applicative (EffectHandler m) where
  pure a = EffectHandler $ \s -> pure (s, [], False, a)
  (EffectHandler f1) <*> (EffectHandler f2) = EffectHandler $ \s -> do
    (s', actions, shouldClose, a) <- f1 s
    (s'', actions', shouldClose', a') <- f2 s
    pure $ (s'', actions <> actions', shouldClose || shouldClose', a a')

instance Monad m => Monad (EffectHandler m) where
  (EffectHandler run) >>= f = EffectHandler $ \s -> do
    (s', actions, shouldClose, a) <- run s
    (s'', actions', shouldClose', a') <- runEffectHandler (f a) s'
    pure $ (s'', actions <> actions', shouldClose || shouldClose', a')

getState :: Applicative m => EffectHandler m State
getState = EffectHandler $ \s -> pure (s, [], False, s)

putState :: Applicative m => State -> EffectHandler m ()
putState s = EffectHandler $ \_ -> pure (s, [], False, ())

spawnAsyncAction :: Applicative m => IO (Maybe Action) -> EffectHandler m ()
spawnAsyncAction action = EffectHandler $ \s -> pure (s, [action], False, ())

closeApp :: Applicative m => EffectHandler m ()
closeApp = EffectHandler $ \s -> pure (s, [], True, ())
