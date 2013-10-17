---
layout: post
title: "firefox sync setup"
category: 
tags: [derp,linux,firefox,android]
---
so this is how to set up a server. i followed to guide from mozilla
and it worked well and was easy to follow.

i got tripped up using my phone as there were some issues when i tried
to use ssl. all these issues stemmed from the FxSync client on
android.

the first was needing to add the intermediate certificate to my ssl
certificate. just concat both files into one.

the other was more tricky. FxSync uses RC4-SHA cipher for ssl. this
was not enabled by default on my server. enabling it fixed my issues
and everything synced up nicely.
