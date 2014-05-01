---
layout: post
title: "metasploit sucking"
category: 
tags: [metasploit]
---

having lots of fun trying to install metasploit-framework on arch. i
get the following fun error while trying to run `msfconsole` (also
after the insane `bundle install` which i had to feed the path to my
user gem directory):

    /usr/lib/ruby/2.0.0/openssl/cipher.rb:61:in `<class:Cipher>': superclass mismatch for class Cipher (TypeError)
      from /usr/lib/ruby/2.0.0/openssl/cipher.rb:22:in `<module:OpenSSL>'
      from /usr/lib/ruby/2.0.0/openssl/cipher.rb:21:in `<top (required)>'
      from /usr/lib/ruby/2.0.0/openssl.rb:20:in `require'
      from /usr/lib/ruby/2.0.0/openssl.rb:20:in `<top (required)>'
      from /home/ren/.local/src/metasploit-framework/lib/msf/ui/console/driver.rb:144:in `require'
      from /home/ren/.local/src/metasploit-framework/lib/msf/ui/console/driver.rb:144:in `initialize'
      from ./msfconsole:148:in `new'
      from ./msfconsole:148:in `<main>'

who knows at this point.
