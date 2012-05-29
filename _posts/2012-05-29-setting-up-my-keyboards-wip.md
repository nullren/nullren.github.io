---
layout: post
title: "setting up my keyboards (wip)"
category: 
tags: [linux, win, fun, derp, rawr]
---
{% include JB/setup %}

i used to be a mac user and apple keyboards are mostly the same as pc
keyboards except the placement of the alt key. i've gotten very used to
having the alt key there and since i am a linux user, i had made use of
the command key as the super key and made it my mod4 key. also, i make
the caps lock key a control key. so, when i got a new keyboard, i had to
make things the way i like them.

### linux console

starting with the linux console, i had to figure out how to make the
caps lock key a control key before i went insane. also, it would be nice
to have the alt key (which is actually the super key, but i swapped the
pieces) function as well. this was actually really easy.

    --- us.map
    +++ my-kbd.map
    @@ -49,6 +49,7 @@
     keycode  56 = Alt
     keycode  57 = space
       control keycode  57 = nul
    -keycode  58 = Caps_Lock
    +keycode  58 = Control
     keycode  86 = less             greater          bar
     keycode  97 = Control
    +keycode 125 = Alt

### x11 keys

where i got into trouble was trying to figure out how to make the alt
key behave like a super and make the super key behave like an alt key in
x11. i already had some Xmodmap rules in place to make the caps lock key
a control key, they are in a file that is called when x11 starts with a
command like `xmodmap ~/.Xmodmap`:

    !! make caps lock a control key
    remove Lock             = Caps_Lock
    keysym Caps_Lock        = Control_L
    add Control             = Control_L
    
    !! make right alt a multi key
    keycode 108             = Multi_key

then to get the alt and super keys switched, i found that the file
`/usr/share/X11/xkb/keycodes/evdev` was the file read, so i just made
the change there

    --- evdev-backup
    +++ evdev
    @@ -65,13 +65,14 @@
      <AB10> = 61;
      <RTSH> = 62;
     
    - <LALT> = 64;
    +  // Swapped LALT and LWIN on keyboard, so need to change codes
    + <LALT> = 133;
      <LCTL> = 37;
      <SPCE> = 65;
      <RCTL> = 105;
      <RALT> = 108;
      // Microsoft keyboard extra keys
    - <LWIN> = 133;
    + <LWIN> = 64;
      <RWIN> = 134;
      <COMP> = 135;
      alias <MENU> = <COMP>;

since this file is automatically loaded for my keyboard, i didn't have
to add anything to my `xorg.conf` which was convenient.

### debugging tools

for the linux console, using `showkey`, `dumpkeys`, and `loadkeys` made
this really simple to find the codes needed. 

in x11, using `xev` and `xmodmap -pke` to get a dump of the keys worked
well, too.

actually figuring out i needed to change
`/usr/share/X11/xkb/keycodes/evdev` was the result of a few greps
looking for where keycode 133 was handled.
