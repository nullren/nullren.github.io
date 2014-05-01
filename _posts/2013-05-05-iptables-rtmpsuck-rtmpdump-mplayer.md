---
layout: post
title: "iptables rtmpsuck rtmpdump mplayer"
category: 
tags: [tv, streams, linux, mplayer, rtmpsuck, iptables, rtmpdump, win]
---

i always forget this stuff, but it's useful when i want to watch
stream in mplayer (which means i can put it on my tv or projector).

first, a history of recent commands used to watch a baseball game.

    ~$ sudo iptables -t nat -A OUTPUT -p tcp --dport 1935 -m owner \! --uid-owner root -j REDIRECT
    ~$ sudo rtmpsuck 
    ~$ sudo iptables -t nat -D OUTPUT -p tcp --dport 1935 -m owner \! --uid-owner root -j REDIRECT
    ~$ rtmpdump -r rtmp://184.75.220.138/cdnlive -a cdnlive -y 2oneh -W http://static.bublu.pw/player/player4.0.swf -p 'http://www.bublu.pw/embed.php?v=2oneh&vw=660&vh=420' -f 'LNX 11,2,202,280' | mplayer -

now what do they mean.

the `iptables` is taking all traffic to port 1935 and will change the
destination to the local machine for everyone except root. so then,
rtmpsuck, the rtmp proxy, is run as root. then all you do is open up
the webpage with the stream you want. if you run under a user other
than root (and you should), then the rtmp stream gets sent to the
proxy (via iptables), and the proxy sniffs out the details and reports
them to the console. since it is run as root, it can then reach the
final destination and you should be able to see the stream in the
webpage. rtmpsuck will show something like:

    ~$ sudo rtmpsuck 
    RTMP Proxy Server v2.4
    (c) 2010 Andrej Stepanchuk, Howard Chu; license: GPL
    
    Streaming on rtmp://0.0.0.0:1935
    WARNING: Trying different position for client digest!
    Processing connect
    app: redirect
    flashVer: LNX 11,2,202,280
    swfUrl: http://static.bublu.pw/player/player4.0.swf
    tcUrl: rtmp://live.bublu.pw/redirect
    pageUrl: http://www.bublu.pw/embed.php?v=2oneh&vw=660&vh=420
    ERROR: WriteN, RTMP send error 9 (16 bytes)
    ERROR: RTMP_ReadPacket, failed to read RTMP packet header
    Closing connection... done!
    
    WARNING: Trying different position for client digest!
    Processing connect
    app: cdnlive
    flashVer: LNX 11,2,202,280
    swfUrl: http://static.bublu.pw/player/player4.0.swf
    tcUrl: rtmp://184.75.220.138/cdnlive
    pageUrl: http://www.bublu.pw/embed.php?v=2oneh&vw=660&vh=420
    Playpath: 2oneh
    Saving as: 2oneh
    INFO: Metadata:
    INFO:   author                
    INFO:   copyright             
    INFO:   description           
    INFO:   keywords              
    INFO:   rating                
    INFO:   title                 
    INFO:   presetname            Custom
    INFO:   creationdate          Sun May 05 18:20:13 2013
    INFO:   videodevice           Hauppauge Cx23100 Video Capture
    INFO:   framerate             30.00
    INFO:   width                 512.00
    INFO:   height                288.00
    INFO:   videocodecid          avc1
    INFO:   videodatarate         500.00
    INFO:   avclevel              31.00
    INFO:   avcprofile            77.00
    INFO:   videokeyframe_frequency2.00
    INFO:   audiodevice           Microphone (4- USB Headphone Se
    INFO:   audiosamplerate       22050.00
    INFO:   audiochannels         1.00
    INFO:   audioinputvolume      4.00
    INFO:   audiocodecid          .mp3
    INFO:   audiodatarate         32.00
    WARNING: ignoring too small audio packet: size: 0
    ^CCaught signal: 2, cleaning up, just a second...

then after we have gotten this information, kill the rtmpsuck process,
and delete the iptables rule we made earlier.

using the fields above as variables, we can construct the rtmpdump
command that pipes to mplayer and shows up on our screen:

    ~$ rtmpdump -r $tcUrl \
                -a $app \
                -y $PlayPath \
                -W $swfUrl \
                -p $pageUrl \
                -f $flashVer | mplayer -

this should work for just about any stream.
