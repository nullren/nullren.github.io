---
layout: post
title: "Category Theory for Programmers Chapter 2"
category:
tags: []
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
