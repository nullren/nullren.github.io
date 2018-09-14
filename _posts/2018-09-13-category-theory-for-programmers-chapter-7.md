---
layout: post
title: "Category Theory for Programmers Chapter 7"
category:
tags: []
---

This helps me because the book was not super rigorous about the
definition of a functor which is the following definition: Let
$\mathscr{A}$ and $\mathscr{B}$ be categories, a *functor*
$F:\mathscr{A} \to \mathscr{B}$ consists of:

* a function $\mathrm{ob}(\mathscr{A}) \to \mathrm{ob}(\mathscr{B})$
  written as $A \mapsto F(A)$;
* for each $A, A' \in \mathscr{A}$, a function $\mathscr{A}(A,A') \to
  \mathscr{B}(F(A), F(A'))$, written as $f \mapsto F(f)$,

satisfying the following axioms:

* $F(f' \circ f) = F(f') \circ F(f)$ whenever $A \to^{f} A' \to^{f'}
  A''$ in $\mathscr{A}$;
* $F(1\_A) = 1\_{F(A)}$ whenever $A \in \mathscr{A}$.

The exercises.

1. Can we turn the `Maybe` type constructor into a functor by defining
  `fmap _ _ = Nothing`?

  To verify this, all we need to do is verify the functor laws
  (axioms) hold. First start with composition.

  Given two functions and their composition `f . g`, does applying
  `fmap` give a composition?

  ```
  1. fmap f _ = Nothing,
     fmap g _ = Nothing,
     fmap (g . f) _ = Nothing (by definition of fmap)
  2. fmap (g . f) _ = fmap g Nothing (from 1)
  3. fmap (g . f) _ = fmap g (fmap f Nothing) (from 1)
  ```
  
  So we do get that composition holds. Next is for an identity
  `id x = x`.

  ```
  1. fmap id _ = Nothing (by definition of fmap)
  2. fmap id _ = id Nothing
  ```

  This is kind of a stupid functor as it completely ignores any
  objects of your type in the left-hand side and condenses everything
  to a singleton. This was alluded to in the chapter.

  > Functors must preserve the structure of a category. If you picture
  > a category as a collection of objects held together by a network
  > of morphisms, a functor is not allowed to introduce any tears into
  > this fabric. It may smash objects together, it may glue multiple
  > morphisms into one, but it may never break things apart.

2. Prove the functor laws for the `reader` functor. From the book,
  turning the type constructor `(->) r` into a functor by defining
  `fmap :: (a -> b) -> (r -> a) -> (r -> b)` which was given as `fmap
  = (.)` (see that `r -> a -> b` in the first two arguments).

  First step is showing composition holds. So, given two functions: `f
  :: a -> b` and `g :: b -> c` and `g . f :: a -> c` we have the
  following given some `h :: x -> a`:

  ```
  1. fmap (g . f) h = (.) (g . f) h (by definition of fmap)
  2. fmap (g . f) h = (g . f) . h = g . (f . h) (by associativity of composition)
  3. fmap (g . f) h = (g . f) . h = g . (fmap f h) (by def'n of fmap)
  4. fmap (g . f) h = (g . f) . h = fmap g (fmap f h) (by def'n of fmap)
  ```

  Next step is to show identity is perserved. It is useful to know
  (or remember or learn) that `id . x = x` and `x . id = x`.

  ```
  fmap id h = (.) id h
            = id . h
            = h
            = id h
  ```

  So we're good. $\blacksquare$

3. Implementing the reader functor is equivalent to implementing a
  compose function as `fmap = (.)`. For that, we've already done in
  chapter 1!

4. Prove the functor laws for the list functor which was defined in
  the chapeter as
  ```haskell
  data List a = Nil | Cons a (List a)
  instance Functor List where
    fmap _ Nil = Nil
    fmap f (Cons x t) = Cons (f x) (fmap f t)
  ```

  First step is showing composition. Starting with our base case,
  `Nil`, we have
  ```
  1. fmap (f . g) Nil = Nil
                      = fmap g Nil
                      = fmap f (fmap g Nil)
  ```
  Because we've shown the base case `Nil`, all that remains is to
  demonstrate this holds for `Cons x t` assuming it holds for `t`
  (induction). 
  ```
  fmap (f . g) (Cons x t) = Cons ((f . g) x) (fmap (f . g) t)
                          = Cons ((f . g) x) (fmap f (fmap g t)) (hypothesis)
                          = Cons (f (g x)) (fmap f (fmap g t))   (def'n of composition)
                          = fmap f (Cons (g x) (fmap g t))
                          = fmap f (fmap g (Cons x t))
  ```
  $\blacksquare$

