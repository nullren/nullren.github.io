---
layout: post
title: creating ssh connections that will cleanly terminate in shell scripts
---

i've noticed that if you write a script that does something not too
different than

    for i in `cat servers.txt`; do
      ssh $i run some command
    done

this will take a while since all of the ssh connections will run
one-by-one. alternatively, you could do background all the ssh
connections with `&`. but this is problematic because if you decided
that you want to prematurely terminate those commands, sending a
SIGINT to your script will not terminate those processes.

sometimes, too, even if you terminate your ssh connection, the remote
processes will keep running. one way to get around this is to run ssh
with the `-t` flag which creates a psuedo-tty. this works well, if you
open a terminal and run `ssh -t remote sleep 3600`. closing the
terminal or sending a SIGINT to the ssh process will also terminate
`sleep` on the remote machine. if you try to background this process,
it will hang until you bring it back to the foreground. so, there must
be something else.

and there is. in the man page for ssh, it has a slightly cryptic
message under `-t`, saying, "Multiple `-t` options force tty
allocation, even if `ssh` has no local tty."

anyway, the trick is to do something like this:

    ssh -tt remote sleep 3600 </dev/null &

now it will run in the background without any problems. sending it a
SIGINT will terminate `sleep` on the remote machine as well. so this
is great.

the `</dev/null` along with the cryptic hint in the man page make
sense, though. what happens is we are forcing `ssh` to create a tty,
but because we are not attached to a local tty, there is no stdin and
things choke. so opening up that pipe with `/dev/null` will not stall
the `ssh` process and it can continue running.

weird.

but awesome.

now you can run many commands, simulataneously, on many machines. and
if you goofed up, you can just terminate the script with a `^c`.

this is a small example of how i used it:

    #!/bin/bash
    trap "kill -1 -$$" SIGINT
    for i in `cat objmanblasters{,}{,}{,}`; do
      ssh $i -tt objmanblast </dev/null &
    done
    sleep infinity


