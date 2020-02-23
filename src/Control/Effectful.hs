module Control.Effectful where

data Effectful effect a where
  ApplyEffect :: Effectful effect x -> (x -> Effectful effect a) -> Effectful effect a
  PureEffect :: a -> Effectful effect a
  RunEffect :: effect x -> (x -> a) -> Effectful effect a

runEffect :: effect a -> Effectful effect a
runEffect eff = RunEffect eff id

instance Functor (Effectful effect) where
  fmap f eff = ApplyEffect eff (pure . f)
  -- fmap f (PureEffect a) = PureEffect $ f a
  -- fmap f (ApplyEffect eff cont) = ApplyEffect eff (fmap f . cont)
  -- fmap f (RunEffect eff g) = RunEffect eff (f . g)

instance Applicative (Effectful effect) where
  pure a = PureEffect a
  eff1 <*> eff2 = ApplyEffect eff1 (<$>eff2)
  -- (PureEffect a) <*> (PureEffect b) = PureEffect $ a b
  -- (PureEffect a) <*> (ApplyEffect eff f) = ApplyEffect eff (fmap (a $) . f)
  -- (PureEffect a) <*> eff = ApplyEffect eff (pure . a)
  -- (ApplyEffect eff f) <*> (PureEffect a) = ApplyEffect eff (fmap ($ a) . f)
  -- (ApplyEffect eff1 f1) <*> (ApplyEffect eff2 f2) = ApplyEffect eff1
  --   (\x1 -> ApplyEffect eff2 (\x2 -> (f1 x1) <*> (f2 x2)))
  -- (ApplyEffect eff f) <*> eff2 = ApplyEffect eff (\x -> f x <*> eff2)
  -- (RunEffect eff f) <*> (PureEffect a) = RunEffect eff (($ a) . f)
  -- (RunEffect eff1 f1) <*> (ApplyEffect eff2 f2) = ApplyEffect (RunEffect eff1 f1)
  --   (\x1 -> ApplyEffect eff2 (fmap x1 . f2))

instance Monad (Effectful effect) where
  eff1 >>= eff2 = ApplyEffect eff1 eff2

runEffectful :: Monad m => (forall x. effect x -> m x) -> (Effectful effect) a -> m a
runEffectful _ (PureEffect x) = pure x
runEffectful run (ApplyEffect eff f) = (runEffectful run eff) >>= runEffectful run . f
runEffectful run (RunEffect effect f) = f <$> run effect
