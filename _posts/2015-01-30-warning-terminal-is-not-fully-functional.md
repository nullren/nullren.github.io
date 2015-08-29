---
layout: post
title: "WARNING: terminal is not fully functional"
---

Scenario: you ssh'd to a new machine and it gives you annoying
warnings when you try to use things like `man`, `less`, or most any
curses based application. The problem is that it does not know how to
speak to your terminal. The fix is simple.

You need to provide a terminfo file from a machine that works without
issues---likely whereever it was you are trying to ssh from---to a
machine that gives you the warnings.

To create an terminfo file, use the command `infocmp(1M)`.

    infocmp >$TERM.info

This `$TERM.info` file can be copied to the other machine and installed
using tic.

    scp $TERM.info remote:$TERM.info
    ssh remote tic -s $TERM.info

Now logging into 'remote' will hopefully allow curses applications to
behave more nicely.
