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

-----

as an extra, i added this rule to udev to sleep when the battery gets
to 2% (or less) giving me time to run and plug in before it powers
off.

inside `/etc/udev/rules.d/99-lowbat.rules`

    # Suspend the system when battery level drops to 2% or lower
    SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="2", RUN+="/usr/bin/systemctl suspend"
    SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="1", RUN+="/usr/bin/systemctl suspend"
    SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="0", RUN+="/usr/bin/systemctl suspend"

now done.
