---
layout: post
title: "Category Theory for Programmers Chapter 10: Natural Transformations"
category:
tags:
- Category Theory
- Category Theory for Programmers
---

A reminder of the naturality condition: G f ∘ α<sub>a</sub> = α<sub>b</sub> ∘ F f

1. Define a natural transformation from `Maybe` to the `List`
   functor. Prove naturality condition for it.

   ```haskell
   asList :: Maybe a -> [a]
   asList Nothing = []
   asList (Just x) = [x]
   ```

   To prove the naturality condition, `fmap f . asList = asList . fmap f`, we have two cases, `Nothing` and `Just x`.

   ```haskell
   fmap f (asList Nothing) = fmap f [] = []
   asList (fmap f Nothing) = asList Nothing = []
   ```

   ```haskell
   fmap f (asList (Just x)) = fmap f [x] = [f x]
   asList (fmap f (Just x)) = asList (Just (f x)) = [f x]
   ```

2. Define at least 2 different natural transformations between
   `Reader ()` and the list functor `[]`. How many different lists of `()` are there?

   ```haskell
   asEmptyList :: Reader () a -> [a]
   asEmptyList _ = []
   ```

   ```haskell
   asOneList :: Reader () a -> [a]
   asOneList r = [r ()]
   ```

   ```haskell
   asTwoList :: Reader () a -> [a]
   asTwoList r = [r (), r ()]
   ```

   And so on, there are infinitely many of these.

3. Define natural transformations between `Reader Bool` and `Maybe`.

   ```haskell
   none :: Reader Bool -> Maybe
   none _ = Nothing
   ```

   ```haskell
   true :: Reader Bool -> Maybe
   true r = Just (r True)
   ```

   ```haskell
   false :: Reader Bool -> Maybe
   false r = Just (r False)
   ```

4. Show that horizontal composition of natural transformations
   satisfies the naturality condition.

   Let `F`, `F'` be functors from categories `A` to `B` and `G`, `G'` functors from categories `B` to `C` with natural transformations `α` from `F` to `F'` and `β` from `G` to `G'`. We must show the naturality condition holds for

   ```haskell
   (G ∘ F) f ∘ (β * α) = (β * α) ∘ (G' ∘ F') f
   ```

   I don't want to do it.


5. No essays.

6. Naturality conditions of transformations between differetn `Op`
   functors. Ie, `Op A B` is `B -> A`, and

   ```haskell
   op :: Op Bool Int
   op = Op (\x -> x > 0)

   f :: String -> Int
   f x = read x
   ```

   `fmap f op :: Op Bool String` Don't know where to go with this...
