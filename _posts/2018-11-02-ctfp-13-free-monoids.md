---
layout: post
title: "Category Theory for Programmers Chapter 13: Free Monoids"
category:
tags:
- Category Theory
- Category Theory for Programmers
---

Challenges

1. Show that an isomorphism between monoids that preserves multiplication must automatically preserve unit.

   Let $A$ and $B$ be monoids and $A \iso B$. Then there exists $f:A \to B$ and
   $f^{-1}:B \to A$ such that $f \circ f^{-1} = \mathrm{Id}_B$ and $f^{-1} \circ f = \mathrm{Id}_A$.
   And because $f$ and $f^{-1}$ preserve multiplication, we have also that
   $f(a a') = $f(a) f(a')$ for all $a, a' \in A$ and $f^{-1}(b b') = f^{-1}(b) f^{-1}(b')$
   for all $b,b' \in B$. Also, because $A$ and $B$ are monoids, there exists
   $e_A \in A$ such that $a e_A = e_A a = a$ for all $a \in A$ and similarly
   $e_B \in B$ such that $b e_B = e_B b = b$ for all $b \in B$.
   
   Let $f(a e_A) = f(a) f(e_A) = f(a)$ for all $a \in A$, then $f(e_A)$ is a candidate for
   identity in $B$ because for all $b \in B$, we have
   $$b f(e_A) = f(f^{-1}(b f(e_A)))$$
   $$= f(f^{-1}(b) f^{-1}(f(e_A)))$$
   $$= f(f^{-1}(b) e_A)$$
   $$= f(f^{-1}(b))$$
   $$= b.$$
   
   Then we have that $e_B f(e_A) = e_B$ by above and $e_B f(e_A) = f(e_A)$ by definition of $e_B$
   and so we have that $$e_B f(e_A) = e_B = f(e_A).$$
   
   Similarly, we can show $$e_A f^{-1}(e_B) = e_A = f^{-1}(e_B).$$ \\(\blacksquare\\)
   

