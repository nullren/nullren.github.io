---
layout: post
title: startx failed to start up
---

So, I rebooted, then I ran `startx` and I was greated with the
following:

```
_XSERVTransSocketUNIXCreateListener: ...SocketCreateListener() failed
_XSERVTransMakeAllCOTSServerListeners: server already running
(EE) 
Fatal server error:
(EE) Cannot establish any listening sockets - Make sure an X server isn't already running(EE) 
(EE) 
Please consult the The X.Org Foundation support 
	 at http://wiki.x.org
 for help. 
(EE) Please also check the log file at "/home/rbruns/.local/share/xorg/Xorg.0.log" for additional information.
(EE) 
(EE) Server terminated with error (1). Closing log file.
xinit: giving up
xinit: unable to connect to X server: Connection refused
xinit: server error
```

There was not another server running as I confirmed with `ps`. Turns
out, when I rebooted, `/tmp/.X11-unix` was not cleaned up.

Solution: `rm -rf /tmp/.X11-unix`

`startx` works again.
