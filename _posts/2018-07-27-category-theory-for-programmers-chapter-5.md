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
