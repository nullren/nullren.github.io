---
layout: post
title: tmux share session for presentation
---

i live in my terminals and this is a reminder to myself and others how
you can create a sort of audience viewable tmux session that lets one
person (me) control the session so that others may view it.

first step is to create a session

    tmux new-session -s presentation

set fixed width and height for the window so clients cannot resize it.
usually, it will adapt to fit the minimum heights and widths amongst
all clients---this stops that.

    tmux set-window-option -t presentation force-width 80
    tmux set-window-option -t presentation force-height 24

now we need to get clients to connect. what i like to do is use ssh
keys and use the `authorized_keys` file to force users of that key into
a read-only tmux session.

create a new keypair

    ssh-keygen -f ~/presentation_key

add an entry in `.ssh/authorized_keys` with the public portion of the
created key pair.

    command="tmux attach-session -t presentation -r" ssh-rsa AAA....

note the `command="..."` section before the actual public key part
that is normally listed. this is a command that runs when the user
logs in and forces them into whatever command you want (it's very
cool).

now give out the `presentation_key` file to other people to use to
connect to your machine. they should be locked in a sort of audience
styled read-only session of your tmux session.

    ssh -i ~/presentation_key my-host

when you are finished, remove the ssh key and its entry from your
`authorized_keys` file, and then terminate the tmux session.
