---
layout: post
title: "systemd xscreensaver lock and suspend on lid close"
category:
tags: []
---
 
i editted one file, `/etc/systemd/logind.conf`, by uncommenting the
line under `[Login]`

    HandleLidSwitch=suspend

then i created the file `/etc/systemd/system/xscreensaver.service`
with the contents

    [Unit]
    Description=Lock X screen using xscreensaver
    Before=sleep.target
    
    [Service]
    User=rbruns
    Type=oneshot
    Environment=DISPLAY=:0
    ExecStart=/usr/bin/xscreensaver-command -lock
    
    [Install]
    WantedBy=sleep.target

then finally enabled it with

    # systemctl enable xscreensaver

tada. lid closes and when i reopen, xscreensaver asks for my password.
