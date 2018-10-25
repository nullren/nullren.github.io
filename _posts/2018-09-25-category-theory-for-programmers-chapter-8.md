---
layout: post
title: "Category Theory for Programmers Chapter 8: Functoriality"
category:
tags:
- Category Theory
- Category Theory for Programmers
---

Last chapter was about functors, but this is about how we can make them useful. In
particular, combining functors via _bifunctors_. A reminder of what
a bifunctor is:

```haskell
class Bifunctor f where
  bimap :: (a -> c) -> (b -> d) -> f a b -> f c d
  bimap g h = first g . second h
  first :: (a -> c) -> f a b -> f c b
  first g = bimap g id
  second :: (b -> d) -> f a b -> f a d
  second = bimap id
```

1. Show the data type `data Pair a b = Pair a b` is a bifunctor. Specifically, we show that if `a` or `b` is a functor, then `Pair` is a functor if 

   ```haskell
   instance Bifunctor (Pair a b) where
     bimap f g (Pair a b) = Pair (f a) (g b)
   ```

2. Show isomorphism between `Maybe` and 

   ```haskell
   type Maybe' a = Either (Const () a) (Identity a)
   ```

   ```haskell
   maybeToEither :: Maybe a -> Maybe' a
   maybeToEither Nothing = Left (Const ())
   maybeToEither (Just x) = Right (Identity x)

   eitherToMaybe :: Maybe' a -> Maybe a
   eitherToMaybe (Left _) = Nothing
   eitherToMaybe (Right (Identity x)) = Just x
   ```

3. Show that `PreList` is an instance of `Bifunctor`,

   ```haskell
   data PreList a b = Nil | Cons a b
   ```

   Let's make this look like some things we know are functors and bifunctors already.

   ```haskell
   data PreList a b = Maybe (a, b)
                    = Either (Const () c) (Identity a, Identity b)
   ```

   I don't really know where to go with this other than we see it's functors and bifunctors all the way down. But it's probably easiest to just implement the interface outright.

4. Show `K2`, `Fst`, and `Snd` define bifunctors in `a` and `b`.

   ```haskell
   interface Bifunctor (K2 c a b) where
     bimap _ _ (K2 c) = K2 c
   interface Bifunctor (Fst a b) where
     bimap f _ (Fst a) = Fst (f a)
   interface Bifunctor (Snd a b) where
     bimap _ g (Snd a b) = Snd a (g b)
   ```
As for the rest of this, a couple good resources about profunctors
are [this
link](http://www.tomharding.me/2017/06/26/fantas-eel-and-specification-18/)
and [this video](https://www.youtube.com/watch?v=OJtGECfksds).
