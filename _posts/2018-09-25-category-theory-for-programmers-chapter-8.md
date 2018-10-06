---
layout: post
title: "Category Theory for Programmers Chapter 8"
category:
tags: []
---

Last chapter was about functors, but this is about how we can make
them useful. In particular, combining functors via _bifunctors_.

1. Show the data type `data Pair a b = Pair a b` is a bifunctor.

   ```
   instance Bifunctor (Pair a b) where
     bimap f g (Pair a b) = Pair (f a) (g b)
   ```
