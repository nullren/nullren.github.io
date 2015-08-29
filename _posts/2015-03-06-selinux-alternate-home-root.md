---
layout: post
title: selinux alternate home root
---

If you have selinux running and you want to use a home root directory
different than `/home`, you'll need to make sure you set the correct
contexts or else things will be funky, eg. SSH will not work very well.

To fix this is actually pretty simple. You can look at the contexts
of `/home` with `ls -Zld /home`. It will look something like:

    # ls -Zld /home
    drwxr-xr-x. 2 system_u:object_r:home_root_t:s0 root root 6 Mar  6 13:16 /home

If you create another directory, like `/rhome` and you want it to have
the same contexts, you can use `chcon` to set it.

    # chcon -u system_u -r object_r -t home_root_t /rhome

And now SSH works! Magic.

