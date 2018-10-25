---
layout: post
title: "Category Theory for Programmers Chapter 2: Types and Functions"
category:
tags:
- Category Theory
- Category Theory for Programmers
---
1. Implement `memoize`
   ```javascript
   const memoize = (f) => {
     const cache = new Map();
     return function() {
       const args = JSON.stringify(arguments);
       if (cache.has(args)) { return cache.get(args); }
       const result = f.apply(null, arguments);
       cache.set(args, result);
       return result;
     }
   }
   ```

2. Memoizing `Math.random` just gives the same number forever.
   ```javascript
   const random = memoize(Math.random)
   ```

3. `Math.random` doesn't take a seed, but the above function can give different
   values with different inputs. Not really sure what the intention here is,
   but this _works_.

4. Only the first function is pure. It gives the same results with no
   side-effects for the inputs. If memoized, nothing changes. (2) reads input,
   so can give different results. (3) has side-effects by writing to stdout
   which can be differnt between calls. (4) has a value that persists between
   calls so successive calls have different values.

5. There are 4 functions from `Bool` to `Bool`. 
   ```javascript
   const id = x => x
   const not = x => !x
   const alwaysTrue = x => true
   const alwaysFalse = x => false
   ```

6. The category with types `Void`, `()`, and `Bool` has the following morphisms:

   - **Id<sub>`Void`</sub>**: `Void` → `Void`
   - **absurd**: `Void` → `a`
   - **Id<sub>`()`</sub>**: `()` → `()`
   - **discard**: `a` → `()`
   - **True<sub>`()`</sub>**: `()` → `Bool`
   - **False<sub>`()`</sub>**: `()` → `Bool`
   - **Id<sub>`Bool`</sub>**: `Bool` → `Bool`
   - **Not<sub>`Bool`</sub>**: `Bool` → `Bool`
   - **True<sub>`Bool`</sub>**: `Bool` → `Bool`
   - **False<sub>`Bool`</sub>**: `Bool` → `Bool`

   The weird thing here is why there are no morphisms _to_ `Void`. For
   this, we fall back to what a morphism is, and here it is a function
   from a set to a set. This also means, that a function takes every
   value of the domain to a unique value in the codomain. In the
   instance of `Void`, we can define a function with `Void` as the
   domain because even though `Void` is the empty set, we can still
   define a function for all x in ∅ (even if there are none). However,
   for a function that does have values, like `Bool`, for there to be
   a function to `Void`, we are saying for all x in `{true, false}`
   there **exists** a unique value in `Void` such that the
   relationship holds. However, there is no value in `Void` so we
   cannot have a function.

   This differs with `()` which is a singleton set, eg `{👾}`. For this
   we can define functions from `()` that send `👾` to some other
   value, and similar, send all values from another domain to just one
   value.
