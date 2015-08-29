---
layout: post
title: Generating Probabilities for PC-PRB-302
---

First, we had a few conditions. The first being that all probabilities
had to be simplified fractions with denominator less than some number,
in my particular generator, it was $10$.

~~Second, any product of two probabilities had to also have a simplified
denominator less than $10$.~~

Lastly, sometimes, we had to have two pairs of probabilities, both
with one common term, (eg, two tuples like $(a, b)$ and $(b,
c)$) such that both the simplified fractions of $ab$ and $bc$ had to
have the same denominator.

To start things off, I made a few types.

```haskell
type Fraction = (Integer, Integer)
type Probability = (Fraction, Fraction)
type Pair = (Probability, Probability)
```

I started off looking for all the simplified fractions that would be
used.

```haskell
allFractions :: [Fraction]
allFractions = liftM2 (,) [1..9] [2..9]

simplifiedFractions :: [Fraction]
simplifiedFractions = filter simplifiedLessThanOne allFractions
  where
    simplifiedLessThanOne (a,b) = a<b && gcd a b == 1
```

~~Then found all the pairs such that their products also had
denominators smaller than $10$.~~ But the code for this was a little
fun.

```haskell
allProbabilities :: [Probability]
allProbabilities = (\x -> liftM2 (,) x x) simplifiedFractions

goodProbabilities :: [Probability]
goodProbabilities = ourRulesFrom allProbabilities
  where
    productLessThanOne ((a,b),(c,d)) = a*c < b*d
    --productDenomLessThanTen ((a,b),(c,d)) = b*d < 10*(gcd (a*c) (b*d))
    ourRulesFrom = filter productLessThanOne
```

I would be done here, except sometimes I wanted two pairs of fractions
with a common term and the products of both pairs to have a common
denominator, or at least one is a multiple of the other.

```haskell
allPairs :: [Pair]
allPairs = liftM2 (,) goodProbabilities goodProbabilities

pairsWithCommonTerm :: [Pair] -> [Pair]
pairsWithCommonTerm = filter onlyOneCommon
  where
    bothSame ((a,b),(c,d)) = (a == c && b == d) || (a == d && b == c)
    bothDiff ((a,b),(c,d)) = (a /= c && b /= d) || (a /= d && b /= c)
    onlyOneCommon x = not $ bothSame x || bothDiff x


pairsWithSameDenom :: [Pair] -> [Pair]
pairsWithSameDenom = filter pairHasSameDenom
  where
    pairHasSameDenom (x,y) = a `mod` b == 0
      where
        a = max x' y'
        b = min x' y'
        x' = timesDenom x
        y' = timesDenom y
    timesDenom = snd . times
    times = simplify . times'
    times' ((a,b),(c,d)) = (a*c, b*d)
    simplify (a,b) = (a `div` d, b `div` d)
      where
        d = gcd a b

goodPairs :: [Pair]
goodPairs = pairsWithCommonTerm . pairsWithSameDenom $ allPairs
```

Then just to finish testing I had this.

```haskell
pick :: IO Pair
pick = runRVar (choice goodPairs) StdRandom
```

The output of `pick` is ultimately what I wanted to use in the
generator.

But to have a little look further, I made another filter.

```haskell
pairsTheSame :: Pair -> Pair -> Bool
pairsTheSame = same pSame
  where
    fSame :: Fraction -> Fraction -> Bool
    fSame (a,b) (c,d) = a == c && b == d
    same s (a,b) (c,d) = (s a c && s b d) || (s a d && s b c)
    pSame :: Probability -> Probability -> Bool
    pSame = same fSame

uniquePairs = nubBy pairsTheSame goodPairs
```
Fun. Now to do this all in java. :(
