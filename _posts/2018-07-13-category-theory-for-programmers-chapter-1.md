---
layout: post
title: "Category Theory for Programmers Chapter 1: Category: The Essence of Composition"
category:
tags:
- Category Theory
- Category Theory for Programmers
---

Just my notes and solutions for Chapter 1.

1. Identity function in javascript
   ```javascript
   const id = x => x
   ```

2. Composition function in javascript. I didn't want to think too hard since
   initial input can have multiple arguments, but the second function must have
   only 1 argument.
   ```javascript
   const compose = (f,g) =>
     function() { return g(f.apply(null, arguments)) }
   ```

3. This seems good enough for me.
   ```javascript
   compose(id, x => x + 2)(2)
   compose(x => x + 2, id)(2)
   ```

4. The world-wide web is a category if the objects are webpages and the
   morphism is "can navigate to" which taken _very_ loosely to mean something
   like "without changing the URL of the current page _A_, is there a series of
   clicks or searches you can perform to eventually navigate topage _B_".

   The second part of the question is not a category since a link on _A_ to _B_
   and a link on _B_ to _C_ does not mean there exists a link on _A_ to _C_.

5. A friend of my friend is not necessarily my friend, so Facebook is not a
   category.

6. A directed graph is a category if for any 3 vertices _a_, _b_, _c_ in a
   graph _G_, there exists edges from _a_ to _a_, _a_ to _b_, _b_ to _c_, and
   _a_ to _c_.
