---
layout: post
title: "a small haskell hscurses (ncurses) example"
category: 
tags: [haskell,win,rawr]
---

    import UI.HSCurses.Curses
    import System.Exit
    import Control.Monad

    main = do
      mainwin <- initScr

      echo False
      keypad mainwin True

      mvWAddStr mainwin 5 10 "Press a key ('q' to quit)..."
      mvWAddStr mainwin 7 10 "You pressed: "
      refresh

      forever $ do
        c <- getCh
        if c == KeyChar 'q' 
          then delWin mainwin >> endWin >> exitSuccess
          else do
            move 7 10
            clrToEol
            mvWAddStr mainwin 7 10 $ "You pressed: " ++ show c
            refresh

the only thing that bugs me is i did not see another function to print a
string besides mvWAddStr. i should look a little harder for that.
