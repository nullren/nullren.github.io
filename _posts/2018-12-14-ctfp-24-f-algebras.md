---
layout: post
title: "Category Theory for Programmers Chapter 24: F-Algebras"
category:
tags:
- Category Theory
- Category Theory for Programmers
---

1. Implement the evaluation function for a ring of polynomials of one variable.

   For a ring $\mathscr{R}$, then define
   
   $$\mathscr{R}\left[t\right] = \left\{ \sum^n_i a_i t^i \,\middle|\, a_i \in \mathscr{R} \right\}$$
   
   Then we can define the following:
   - $0_{\mathscr{R}\left[t\right]} = 0_{\mathscr{R}} t^0$
   - $1_{\mathscr{R}\left[t\right]} = 1_{\mathscr{R}} t^0$
   - for $\left(\sum a_i t^i\right), \left(\sum b_i t^i\right) \in \mathscr{R}\left[t\right]$, we have
     - $\left(\sum a_i t^i\right) +_{\mathscr{R}\left[t\right]} \left(\sum b_i t^i\right) = \sum (a_i + b_i) t^i\$
     - $\left(\sum a_i t^i\right) \times_{\mathscr{R}\left[t\right]} \left(\sum b_i t^i\right) = \sum \left(\sum_{x+y=i} a_x b_y\right) t^i\$
   
