---
layout: post
title: "time out a process in haskell"
category: 
tags: [haskell, wtf, rawr, fail]
---
i'm trying to figure out a good way to timeout a process in haskell. i
will look later to see if someone actually already did this. the problem
i have is that i want to exit the program with a timeout failure which
is the opposite of what i have so far:

{% highlight haskell %}
import Control.Concurrent
import Control.Monad
import System.Exit

timer n = threadDelay (n*1000000)

timeout n proc = do
  i <- forkIO proc
  timer n
  putStrLn "timed out!"
  killThread i

main = do
  timeout 1 $ forever $ putStrLn "bob!"
{% endhighlight %}

this is just a sketch of what i worked from. what i think i want to do
is fork a timer process and when it ends, i want the entire program to
end. i've tried adding `exitFailure` but it only ends that thread, not
the entire process.

*just kidding*

i figured it out. i did something awful like this:

{% highlight haskell %}
do
  p <- myThreadId
  c <- forkIO (threadDelay 2000000 
            >> putStrLn "child wins"
            >> killThread p)
  threadDelay 3000000
  putStrLn "parent wins"
  killThread c
{% endhighlight %}

i'll have to find something prettier...later.
