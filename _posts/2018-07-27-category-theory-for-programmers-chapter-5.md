---
layout: post
title: "Category Theory for Programmers Chapter 5"
category:
tags: []
---

1. Let \\(x,y \in \mathbf{C}\\) be terminal objects. Because \\(x\\)
   is terminal, \\(\exists f:y \to x\\) and because \\(y\\) is
   terminal, \\(\exists g:x \to y\\). The composition \\(f \circ g:x
   \to x\\) is an arrow, but by definition, there is one and only one
   arrow from \\(x\\) to \\(x\\), and being an object in a category,
   it must have an identity, so \\(f \circ g = \mathrm{Id}_x\\).
   Similarly, \\(g \circ f:y \to y\\) and there can only be one
   morphism from \\(y\\) to \\(y\\) and so \\(g \circ f =
   \mathrm{Id}_y\\). Therefore, \\(x \cong y\\). \\(\blacksquare\\)

2. Let \\(c\\) be the product of \\(a\\) and \\(b\\). This means we
   utilize the universal construction and get the relations:
   - \\(c \to a\\)
   - \\(c \to b\\)
   - for any other \\(c' \to a\\) and \\(c' \to b\\), we have that
     \\(c' \to c\\)

   So the question here is, given a poset, what is the product of
   objects? First step is to define what the relation of our poset
   is.

   Let \\(a \to b\\) if \\(a\\) is an ancestor of \\(b\\). Then our
   relations read as:
   - \\(c\\) is an ancestor of \\(a\\)
   - \\(c\\) is an ancestor of \\(b\\)
   - for any other ancestor \\(c'\\) of \\(a\\) and \\(b\\), we have
     that \\(c'\\) is an ancestor of \\(c\\).
   This makes \\(c\\) the most immediate ancestor of both \\(a\\) and
   \\(b\\) (and does not exclude \\(c\\) being \\(a\\) or \\(b\\)).
   However, this does not really work. If we look at the product of
   two siblings, we are saying the mother is an ancestor of the father
   and vice-versa.

   In the comments, a relationship of \\(a\\) is the boss of \\(b\\)
   was given by the author. In this case, we would have the product of
   two teammates to be their immediate boss, but this also assumes no
   person has more than one boss.

   However, for a _real_ example that works, let \\(a \to b\\) be
   given by \\(a,b \in \mathbf{Set}\\) and \\(a \subseteq b\\). Then
   we have that the product of \\(a\\) and \\(b\\) is a subset \\(c\\)
   such that for any other subset \\(c'\\), \\(c' \subseteq c\\). So
   the product is the largest subset of both.

   Another way to think about it is look looking at the composition of
   morphisms from the text. \\(p' = p \circ m\\) which looks like
   \\(c' \to b = c' \to c \to b\\) and it seems to say, for any path,
   there's an object that you can insert between that works for both
   \\(a\\) and \\(b\\).

3. The coproduct of two elements in a poset would be flipping the
   relations around. In the case of subsets, the product of
   sets \\(a\\) and \\(b\\) would be the set \\(c\\) such that for any
   other set \\(c'\\) that contains both \\(a\\) and \\(b\\), we have
   that \\(c \subseteq c'\\), or that the product is the smallest set
   that contains both \\(a\\) and \\(b\\). This is the opposite of the
   product which is the largest set that is a subset of both \\(a\\)
   and \\(b\\). I guess you could think of this as the lim-sup of
   subsets of both \\(a\\) and \\(b\\). WHereas the coproduct would be
   lim-inf of sets that contain \\(a\\) and \\(b\\).
