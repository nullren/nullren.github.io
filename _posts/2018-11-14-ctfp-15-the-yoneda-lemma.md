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
   
   Need to verify `phi . psi = id` and `psi . phi = id`.
   
   - Want to show: `(phi . psi) fa = fa`
   - `phi (psi fa)`
   - `phi (\h -> psi fa h)`
   - `phi (\h -> fmap h fa)`
   - `(\h -> fmap h fa) id`
   - `fmap id fa`
   - `fa`
   
   Done.
   
   - Want to show: `(psi . phi) nt = nt`
   - `psi (phi nt)`
   - `psi (nt id)`
   - `(\fa h -> fmap h fa) (nt id)`
   - `(\h -> fmap h (nt id))`
   - ...👐 something about natural transformations and functors...
   - `(\h -> nt (h . id)`
   - `(\h -> nt h) = nt`
   
   Feels like to go this way, we have to look inside the natural transformation
   or `fmap` somehow to un-pack it. I can't think of what's needed.
   
   
2. How does the Yoneda lemma work for functors from a discrete category?

   Discrete categories only contain objects and identity morphisms. So
   for the Yoneda lemma which states 
   
   $$ [\mathscr{C}, \mathbf{Set}](H^A, F) \cong F(A) $$
   
   we have that the set of natural transformations from $H^A$ to $F$ is the
   same as $F(A)$, then we only have that identity morphism on the RHS, 
   and so on the LHS, we only have the identity natural transformation,
   or specifically, a singleton set.

3. Construct another representation of the data type (`[()]`, list of units
   encoding $\mathbb{N}$) using the Yoneda lemma for the list functor.
   
   

