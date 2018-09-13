---
layout: post
title: "Category Theory for Programmers Chapter 7"
category:
tags: []
---

This helps me because the book was not super rigorous about the definition of a functor which is the following definition: Let $\mathscr{A}$ and $\mathscr{B}$ be categories, a *functor* $F:\mathscr{A} \to \mathscr{B}$ consists of:

* a function $\mathrm{ob}(\mathscr{A}) \to \mathrm{ob}(\mathscr{B})$ written as $A \mapsto F(A)$;
* for each $A, A' \in \mathscr{A}$, a function $\mathscr{A}(A,A') \to \mathscr{B}(F(A), F(A'))$, written as $f \mapsto F(f)$,

satisfying the following axioms:

* $F(f' \circ f) = F(f') \circ F(f)$ whenever $A \to^{f} A' \to^{f'} A''$ in $\mathscr{A}$;
* $F(1_A) = 1_{F(A)}$ whenever $A \in \mathscr{A}$.

1. Can we turn the `Maybe` type constructor into a functor by defining
   `fmap _ _ = Nothing`?

   Does this preserve identities? So, really, what we need to be true is that when you have an object $a$ and identity $id$ that you have $id_F(F_a)$ is also true. Meaning, if we have `id`, then `fmap id` should also be an identity.

