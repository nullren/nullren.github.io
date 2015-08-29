---
layout: post
title: Generating Distributions for PC-PRB-301
---

This is the first confusing thing I have come across on this
generator.

I want to generate a list of integers that sum to a particular
integer. So far, I have decided this is the same as picking a random
term in the expansion of $(x_1 + \dots + x_n)^k$.

The first thing I thought of doing was someting like this:

```haskell
import Control.Monad
import Data.List

import Data.Random
import Data.Random.Extras
import Data.Random.Source.Std

-- settings
sampleSize = 5
decimalPlaces = 3

one = 10^decimalPlaces
target = one

pick :: Integer -> IO Integer
pick x = runRVar (choice [0..(x-1)]) StdRandom

countOfEach :: [Integer] -> [Int]
countOfEach = map (\x -> length x) . group . sort

makeList :: IO [Int]
makeList = fmap countOfEach $ sequence $ take one $ cycle [pick
sampleSize]
```

`makeList` is now a vector of numbers that add up to what we want. The
problem is they are much too uniform.
