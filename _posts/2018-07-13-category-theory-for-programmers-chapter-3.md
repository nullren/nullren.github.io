---
layout: post
title: "Category Theory for Programmers Chapter 3"
category:
tags: []
---

The notion of orders is introduced here and it's not totally clear from the
text what their definitions entail or what they're actually trying to convey if
you don't already know what _preorders_, _partial orders_, and _total orders_
are. Preorders are pretty straight forward and there isn't much to add. This
mostly just states things are related to themselves and that the _transitivity_
of the relation holds.

Partial orders add _antisymmetry_ by stating if _a_ is related to _b_ and _b_
is related to _a_, then _a_ is _b_. This makes cycles impossible.

Lastly, total orders have the _connex relation_ which means for any two
elements, they can be related in some way, either _a_ is related to _b_ or _b_
is related to _a_.

1. Generating free categories from graphs.
   1. One node, **v**, and no edges. There exists only one morphism,
      _1_<sub>**v**</sub>, the identity morphism.
   2. One node, **v**, and one directed edge, _f_. There exists the following
      morphisms: _1_<sub>**v**</sub>, _f_, _f_ ∘ _f_, _f_ ∘ _f_ ∘ _f_, ...
   3. A graph with two nodes, **v**, **w**, and one edge _f_:**v** → **w**. There
      exists the following morphisms: _1_<sub>**v**</sub>, _f_,
      _1_<sub>**w**</sub>.
   4. A graph with one node, **v**, and 26 edges, _a_, _b_, ..., _z_. There
      exists the following morphisms: _1_<sub>**v**</sub>, _a_, _aa_,
      _aardvark_, ..., _zyzzyvas_, _zzzzzzzzz_, ...
2. Describe the order.
   1. A set of sets with inclusion as the relation. For this to be a total
      order, for any two sets _A_ and _B_, either _A_ ⊂ _B_ or _B_ ⊂ _A_. But
      without extra information, it's possible for neither to hold, ie,
      discrete sets **{**_a_**}** and **{**_b_**}**. So it's a _partial order_.
   2. I'm guessing this is also a partial order since types are like sets. You
      can have subtypes that in disjoint subtype trees.
3. (`Bool`, _AND_) is a monoid with `true` as identity. (`Bool`, _OR_) is a
   monoid with `false` as identity.
4. (`Bool`, _AND_) as a category has two morphisms:
   1.  _1_<sub>`Bool`</sub> = _t_:`b`↦`b` _AND_ `true`,
   2.  _f_: `b` ↦ `b` _AND_ `false`.
   Any compositions just get us back to those:
   1. _t_ ∘ _f_ = _f_ ∘ _t_ = _f_ ∘ _f_ = _f_,
   2. _t_ ∘ _t_ = _t_ = _1_<sub>`Bool`</sub>.
5. (ℤ/3ℤ, +) has morphisms (+ `0`) =
   _1_<sub>ℤ/3ℤ</sub>, (+ `1`), and (+ `2`) = (+ `1`) ∘ (+ `1`). There are no
   more morphisms as (+ `2`) ∘ (+ `1`) = (+ `0`).
