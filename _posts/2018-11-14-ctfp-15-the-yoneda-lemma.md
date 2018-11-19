---
layout: post
title: "Category Theory for Programmers Chapter 15: The Yoneda Lemma"
category:
tags:
- Category Theory
- Category Theory for Programmers
---


1. Show that the two functions `phi` and `psi` that form the Yoneda isomorphism
   in Haskell are inverses of each other.
   
   ```haskell
   phi :: (forall x . (a -> x) -> F x) -> F a
   phi alpha = alpha id
   ```
   ```haskell
   psi :: F a -> (forall x . (a -> x) -> F x)
   psi fa h = fmap h fa
   ```
   
   
2. How does the Yoneda lemma work for functors from a discrete category?

3. Construct another representation of the data type (`[()]`, list of units
   encoding $\mathbb{N}$) using the Yoneda lemma for the list functor.

