---
layout: post
title: "selinux and a new httpd root"
category:
tags: []
---

The following couple commands will set the correct context for the httpd user
after installing nginx. The most annoying parts however or not remembering how
to set the selinux context for the directories. Normally, I overwrite the
existing nginx config directory, so this isn't much of an issue. However, I
have somewhat standardized on the `/srv/<protocol>` pattern for storing files.
This requires usually adding it to the selinux context pattern.

  sudo /usr/sbin/semanage fcontext -a -t httpd_config_t "/etc/nginx(/.*)?"
  sudo /usr/sbin/semanage fcontext -a -t httpd_sys_content_t "/srv/http(/.*)?"

Afterwards, I should be able to then restore context for the files when I add new ones.

  sudo restorecon -Rv /etc/nginx
  sudo restorecon -Rv /srv/http/
