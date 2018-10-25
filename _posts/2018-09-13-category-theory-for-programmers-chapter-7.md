---
layout: post
title: "Category Theory for Programmers Chapter 7: Functors"
category:
tags:
- Category Theory
- Category Theory for Programmers
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

Another thing that ended up being really helpful was considering what are our
categories? When thinking about haskell, we start with the category of
haskell types, **Hask**. The morphisms then are just haskell functions as
they're all from some type to another type.

So when thinking about functors in hasekll, our objects are elements of
**Hask** and our morphisms are just haskell functions.

The exercises.

1. Can we turn the `Maybe` type constructor into a functor by defining
   `fmap _ _ = Nothing`?
   
   To verify this, all we need to do is verify the functor laws
   (axioms) hold. First start with identity.
  
   The `Maybe` type constructor takes types from **Hask**, eg `x`, and turns them into new types, `Maybe x` which is just a subset of **Hask**. The identity function on these new types uses the same identity function from **Hask** which is why we can say `fmap id = id` in haskell. So for us to verify our "functor", we need to verify this equality.
 
   ```
   1. fmap id (Just x) = Nothing (by definition of fmap)
   2. fmap id (Just x) = id Nothing (by definition of id)
   3. fmap id (Just x) = id (Just x) (by definition of fmap id)
   4. id (Just x) = id Nothing (by 2 and 3)
   5. (Just x) /= Nothing
   ```
   
   So we do not get that this definition of `fmap` gives us a functor.

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

