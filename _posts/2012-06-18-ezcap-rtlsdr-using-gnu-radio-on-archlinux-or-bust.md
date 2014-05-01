---
layout: post
title: "ezcap rtlsdr using gnu radio on archlinux or bust"
category: 
tags: [linux, derp, radio, ezcap, rtlsdr]
---
so i figure since i finally got this thing from deal extreme after
waiting two months or so, i ought to figure out how to set it up so i
can start listening to things. we'll figure this out together!

## first steps

when i first tried this, i got nowhere. so not knowing anything and
having [reddit](//reddit.com/r/rtlsdr) as my only resource, we'll see
where we get this time around.

### udev rule

i added this file, `20-rtl_sdr.rules`:

    SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2838", GROUP="radio", MODE="0660", SYMLINK+="rtl_sdr"

i added myself to the `radio` group.

### installing gnuradio

i installed the `gnuradio-git` package in the archlinux aur, but i had
to install `python2-cheetah` as well. i added it to the `deps` of the
`PKGBUILD` in gnuradio.

