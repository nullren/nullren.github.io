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

2. To figure out what the product of two objects in a poset would be
   it helps to define what the relation in our poset would be. To take
   a fun example, the relation \\(a \to b\)) is defined as \\(a\\) is
   a descendent of \\(b\\). This forms a poset if we allow one to be a
   descendent of oneself (identity arrow) and transitivity is quick to
   see.

   Let \\(c\\) be the product of \\(a\\) and \\(b\\). This means we
   utilize the universal construction and get the relations:
   - \\(c \to a\\)
   - \\(c \to b\\)
   - for any other \\(c' \to a\\) and \\(c' \to b\\), \\(c' \to c\\)

   Or in english, we have:
   - \\(c\\) is a descendent of \\(a\\)
   - \\(c\\) is a descendent of \\(b\\)
   - for any other \\(c'\\) that is a descendent of \\(a\\) and
     \\(b\\), we have that \\(c'\\) is a descendant of \\(c\\).

   So in this poset where arrows denote descendents, then the product
   of two people would be the most recent descendant of the two. For a
   father and a son, this would yield the son. But for two people who
   are not descended from either, this would be one of their children.
