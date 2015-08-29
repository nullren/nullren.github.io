---
layout: post
title: automatically create homedir on login
---

add this to `/etc/pam.d/postlogin`

    session     required      pam_mkhomedir.so skel=/etc/skel/ umask=0077
