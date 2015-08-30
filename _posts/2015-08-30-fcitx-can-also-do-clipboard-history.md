---
layout: post
title: "fcitx can also do clipboard history"
category:
tags: []
---

in addition to providing input methods for chinese, fcitx can also do
some basic clipboard history which i did not know.

in my .xinitrc

    export GTK_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    export XMODIFIERS="@im=fcitx"
    fcitx -d

and then i installed the following on archlinux

    fcitx
    fcitx-googlepinyin
    fcitx-configtool
    fcitx-gtk2

fcitx-gtk2 was required to get it to work in things like firefox.
