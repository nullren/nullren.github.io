---
layout: post
title: "Category Theory for Programmers Chapter 14: Representable Functors"
category:
tags:
- Category Theory
- Category Theory for Programmers
---

The [youtube video of this chapter][1] was very helpful.

  [1]: https://www.youtube.com/watch?v=KaBz45nZEZw

1. Show that the hom-functors map identity morphisms in $C$ to
   corresponding identity functions in **Set**.
   
   Let $C(a,-)$ be a hom-functor. We want to show that for some
   identity morphism $\mathrm{Id}_x : x \to x$ in $C$ is an 
   identity function in the lifted space $C(a,x)$, or specifically, we
   get a function such that for any element $x' \in C(a,x)$ we get $x'$.
   
   However, this is pretty easy to see since $x':a \to x$ is a morphism in
   $C$ and lifting $\mathrm{Id}_x$ is done by composition, we have
   $x' \circ \mathrm{Id}_x = x'$.
   
2. Show that `Maybe` is not representable.

   So, to be representable, we need to pick an object $a \in C$ from which
   to create a natural transformation from $H^a \to F$, where in this case $F$
   is the `Maybe` functor.
   
   In particular, we need to pick some function $f:a \to x$ such that we can
   recreate some `Maybe x`. Similarly, we need to go the other way, where
   given a `Maybe x` we can create some function $f:a \to x$.
   
   So, let's assume we have those natural transformations $\alpha$ and $\beta$.
   $\alpha$ needs to encapsulate $f$ entirely into a `Maybe`, however there
   are two values it could take, `None` or `Just x'`. $\beta$ needs to accept
   a `Maybe` and recreate our $f$. However, for $\alpha$ to be a function, 
   it can only give one value when applied to $f$. 
   
3. Is the `Reader` functor representable?

   `Reader a x` is a function from $a \to x$. To be representable, we need
   to be able to encapsulate some function $f:a \to x$, and in this instance
   $\alpha$ and $\beta$ are just the identity natural transformations.
   
4. Using `Stream`, memoize a function that squares its argument.

   A `Stream` is represented by $\mathbb{N}$, and so all we need to do
   is find an isomorphism between $\mathbb{N}$ and the domain $X$ of our
   function mapping $x \in X$ to $x^2$. Then all we need to do then
   use $X \to \mathbb{N}$ to tabulate our `Stream`. This is suitable for any
   countably infinite domain $X$.
   
5. Show that `tabulate` and `index` for `Stream` are indeed the inverse of
   each other.
   
   ```haskell
   instance Representable Stream where
     type Rep Stream = Integer
     tabulate f = Cons (f 0) (tabulate (f . (+1)))
     index (Cons b bs) n = if n == 0 then b else index bs (n - 1)
   ```
   
   We need to do two things, show `tabulate . index` is an identity of
   `Stream x` and show `index . tabulate` is an identity of `Integer -> x`.
   
   Let `s = Cons a0 (Cons a1 (Cons a2 (...)))` and to show this is the same as
   `(tabulate . index) s`, we need to start the base case that
   `s = Cons a0 ((tabulate . index) (Cons a1 (...)))`.
   
   Rewriting and expanding we have:
   - `tabulate (index s)`
   - `Cons (index s 0) (tabulate ((index s) . (+1)))`
   - `Cons (index (Cons a0 (...)) 0) (tabulate ((index s) . (+1)))`
   - `Cons a0 (tabulate (\n -> index s (n+1))`
   - `Cons a0 (tabulate (\n -> index (Cons a0 (Cons a1 (...))) (n+1))`
   - `Cons a0 (tabulate (\n -> if (n+1==0) then a0 else index (Cons a1 (...))) (n))`
   - `Cons a0 (tabulate (\n -> index (Cons a1 (...))) (n))`
   - `Cons a0 (tabulate (index (Cons a1 (...))))`
   - `Cons a0 ((tabulate . index) (Cons a1 (...)))`
   
   That was painful but proves our base case. Now the hypothesis is
   - `Cons a0 (... (Cons aN ((tabulate . index) (Cons aN1 (...)))))`
   - Using pretty much everything the same as above, it's not a stretch to see
   - `Cons a0 (... (Cons aN (Cons aN1 ((tabulate . index) (Cons aN2 (...)))))))`
   
   I don't want to go the other way, but it's basically the same game of just expanding definitions.
   
6. The functor `Pair a = Pair a a` is representable. Guess the type.

   It can be represented by any type of cardinality 2, eg, `bool`.
   - `tabulate f = Pair (f true) (f false)`
   - `index (Pair x y) b = if b then x else y`
   
