---
layout: post
title: "Differential Topology   Lecture 1 Notes"
category: 
tags: [math, topology, differential topology, ucla, math 225a, manolescu]
---

This is the first of a series of lecture notes. I am going to try to
keep this up so that it forces me to review the notes I have taken in
lectures. Unfortunately, I cannot guarantee these will be any good.

### Highlights of the Course

1. The first interesting theorem we will cover is Whitney's Theorem: Every $n$-dimensional
smooth manifold can be embedded in $\mathbb{R}^{2n+1}$.

   An embedding is an injective map with no self intersections.

2. Jordon Curve Theorem: Every simple closed curve in $\mathbb{R}^2$
splits $\mathbb{R}^2$ into connected components.

   Jordon-Brower Theorem is the generalization that a simple closed $n-1$
dimensional manifold splits $\mathbb{R}^n$.

3. Euler Characteristic of a manifold $M$, $\chi(M)$ ($\chi = V - E + F$). For example
$\chi(\mathbb{R}) = 1$, $\chi(S^2) = 2$, $\chi(T^2) = 0$.

   Hedgehog Theorem says $S^2$ cannot be combed. This is the same as saying
there is always a still point or there is always a point with no wind on
earth.

   A compact manifold $M$ can be combed if and only if $\chi(M) = 0$, e.g.
$T^2$ can be combed.

   Fixed point problems. Then $f \: M \to M$ a smooth deformation of the
identity, if $\chi(M) \neq 0$, then $f$ has at least one fixed point. A
circle rotated by $\theta$ has no fixed points.

### Topological Manifolds

> **Definition** An $n$-dimensional *topological manifold*, $M$, is a
> topological space such that:
> 1. $M$ is Hausdorff,
> 2. $M$ is second-countable,
> 3. $M$ is locally euclidean.

> **Definition** A *chart* on $M$ is a pair $(U,f)$, $U \subset M$ such
> that $f \: U \to V \subset \mathbb{R}^n$ and $V$ is open.

> **Example** Two rays in $\mathbb{R}^2$ shooting out from the origin.
> Let $f$ be the projection of these two lines to $\mathbb{R}$.

Examples of spaces that are not manifolds.
