---
layout: post
title: nginx proxy_pass DNS funkiness
---

This was noticed with Sugarcane. Sugarcane uses an AWS ELB to direct
traffic to its servers. The issue at hand is that the domain used to
point to the ELB does not have static IPs and this is something Amazon
has warned about.

How this affects nginx is that nginx resolves the domains you pass to
it once at startup and holds onto them. So if nginx has been running
for two months straight, the IPs it had resolved for the ELB are
probably not current.

This [nginx ML thread][1] talks about a work-around. If you use a
variable in `proxy_pass`, they will be dynamically resolved and cached
for about 5 minutes.

```diff
--- old/nginx.conf  2015-02-17 11:22:12.720729211 -0800
+++ new/nginx.conf  2015-03-06 10:57:22.829696006 -0800
@@ -36,7 +36,9 @@
         # proxy everything to a sugarcane test site
         #
         location / {
-            proxy_pass  http://test.sugarcane.rb;
+            resolver 192.168.21.84
+            set $scelb  "test.sugarcane.rb";
+            proxy_pass http://$scelb;
             proxy_set_header  X-Real-IP  $remote_addr;
             proxy_read_timeout 700;
             proxy_set_header Host $http_host;

```

  [1]: http://forum.nginx.org/read.php?2,215830,215832#msg-215832
