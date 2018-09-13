---
layout: post
title: "Category Theory for Programmers Chapter 6"
category:
tags: []
---

1. Show the isomorphism between `Maybe a` and `Either () a`.

   ```haskell
   maybeToEither :: Maybe a -> Either () a
   maybeToEither None = Left ()
   maybeToEither Just x = Right x

   eitherToMaybe :: Either () a -> Maybe a
   eitherToMaybe Left _ = None
   eitherToMaybe Right x = Just x
   ```
  
