module Data.Empty where

data Empty a = Empty

instance Functor Empty where
  fmap _ _ = Empty

instance Applicative Empty where
  _ <*> _ = Empty
  pure _ = Empty

instance Monad Empty where
  _ >>= _ = Empty
