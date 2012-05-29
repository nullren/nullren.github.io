---
layout: post
title: "setting up logitech k750 keyboard and mx mouse on linux"
category: 
tags: [linux, logitech, peripherals, win]
---
{% include JB/setup %}

this started off as really frustrating but turned out to be really
simple. the problem is that these two devices use logitech's "unifying"
technology where both devices can use the same usb dongle. the problem
was that there was no good way to configure that on linux. initially, i
had tried to do it in virtual box but i got into the problem of not
being able to figure out which usb device i was attaching to the vm.

Benjamin Tissoires [wrote a little c
program](https://groups.google.com/forum/?fromgroups#!msg/linux.kernel/zYS6yddI8yU/9cMvg3k9xTYJ)
which does the unifying. the only problem is there isn't a way to
decouple devices from a dongle, but that won't really matter.

to use this, compile the program

    $ gcc -o pairing_tool pairing_tool.c

plug in your usb dongler and look for it in dmesg

    $ dmesg | tail

mine looked something like this

    logitech-djreceiver 0003:046D:C52B.0003: hiddev0,hidraw0: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1a.2-1/input2

the important part from this is getting the `hidraw0` part. then to pair
the devices to the dongle, just run the tool and follow the
instructions:

    $ sudo ./pairing_tool /dev/hidraw0

it was simple. thanks to Mr. Tissoires for making this tool.
