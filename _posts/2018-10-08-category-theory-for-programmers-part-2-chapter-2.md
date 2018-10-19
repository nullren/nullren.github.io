---
layout: post
title: "Category Theory for Programmers Part 2 Chapter 2"
category:
tags: []
---

Challenges

1. How would you describe a pushout in the category of C++ classes?

   C++ classes as a category where morphisms connect subclasses to
   superclasses, eg, in java we have,
   
   ```java
   class A {}
   class B extends A {}
   class C extends A {}
   ```
   
   which would represent the span $B \leftarrow A \to C$.

   The _pushout_ would be a class $P$ and arrows $B \to P \leftarrow C$, such
   that for any other $Q$ and arrows $B \to Q \leftarrow C$, there exists
   an arrow $P \to Q$.
   
   Specifically, it would look something like
   ```java
   class P extends B, C {}
   ```
   
   And so any other class $Q$ that also extends both $B$ and $C$, we would
   have that $P \to Q$, or that `class Q extends P {}`.
   

2. Show that the limit of the identity functor `Id :: C -> C` is the
   initial object.
   
   Reminder: initial objects are an object $i$ such for every $x$ in $C$, there
   exists exactly one morphism $i \to x$.
   
   To find the limit of the identity functor, we need to construct cones,
   so a functor $\Delta_c$ just maps any object $a \in C$ to $c$, and thus
   natural transformation from $\Delta_c \to Id$ looks like an initial object.
   
   If we can find such a $c$, we need to show that it is initial. In the comments
   it was hinted that what is unique is the morphism from any cone to the limiting
   cone.
   

3. Subsets of a given set form a category. A morphism in that
   category is defined to be an arrow connecting two sets if the
   first is the subset of the second. What is a pullback of two
   sets in such a category? What’s a pushout? What are the initial
   and terminal objects?
   
   $A \to B$ means $A \subset B$.
   
   A pullback of two morphisms $X \to Z \leftarrow Y$ is an object $P$ and
   morphisms $X \leftarrow P \to Y$ such that for any other object $Q$ and
   morphisms $X \leftarrow Q \to Y$, we have there exists a unique morphism,
   the mediating morphism, such that $Q \to P$.
   
   Translating $\to$ to $\subset$ gives the following: A pullback of two sets,
   $X, Y$ such that both are subsets of $Z$, is a set $P$ such that $P$ is a
   subset of both $X$ and $Y$. For any other set $Q$ that is a subset of $X$
   and $Y$, we have that $Q$ is a subset of $P$. So we have that the pullback
   of $X$ and $Y$ is the intersection of $X$ and $Y$.
   
   The pushout of would be the union of $X$ and $Y$. So any other set $Q$
   that $X$ and $Y$ are both subsets of, $P$ would also be a subset.
   
   The initial object would be the empty set and the terminal object would be
   the union of all sets.

4. Can you guess what a coequalizer is?

   Creates a categorical equivalence relation between outputs of two morphisms.
   The equalizer reduces inputs so the results are the same.

5. Show that, in a category with a terminal object, a pullback
   towards the terminal object is a product.
   
   The terminal object has an arrow from each object, so the object we pullback
   towards has a sort of "global" presence.

6. Similarly, show that a pushout from an initial object (if one
   exists) is the coproduct.
   
   Similarly, every object has an arrow from the initial object.
