---
layout: post
title: "setting up gnupg on linux"
category: 
tags: [linux, gpg, pgp, win, rawr]
---
this is written as a guide to not only remind myself but also help
others with some of the basics of setting up their gnupg.

## gnupg

---------------------------------------------------------------------

### intro

first some general notes about gnupg (gpg) and the mechanisms of encrypting,
signing, and trust. gpg is a large program and implements a lot of
interesting math from the openpgp protocol. it is easy to become
overwhelmed.

##### encryption

most people know what encryption is and what it is useful for: hiding
messages. perhaps later i will write about different mechanisms of
encrypting values as this is pretty interesting to me but that is not
for this entry. what this paper is about is how gpg is useful.

unfortunately, most people do not feel they need strong encryption in
their emails---and they are not completely wrong. "normal" people do not have
secrets that require strong encryption, so it should not be forced
upon them. but gpg provides something that i feel is more important
than guarding secrets. it provides a way to attach your identity to a
document.

#### digital signatures

before long, i suspect digital signatures will become much more
important. the reason i think this is that digital signatures solve a
problem that have plagued many of us in the recent age: signing forms.

if a company has a form they need you to sign, there are a few ways
this gets done:

  1. they mail you the form, you sign it, and then you mail it back.
  2. they fax you the form, you sign it, and then you fax it back.
  3. they email you the form, you print it, you sign it, you scan it,
     and then you email it back.

i personally have signed a form and sent it back using each of those
three methods, and method (3) makes me cringe every time i think about
it.

but why do we sign forms? what is it about our hand written signature
that makes this okay?

our signatures are supposed to be unique identifiers, meaning my
person should be the only person that can make my signature.
unfortunately, it is very simple to forge a signature as i'm sure any
naughty school child may have done (probably more unsuccessfully than
not).

digital signatures provide basically the same function, but they add
something extra. not only does a digital signature essentially give a
stamp of approval unique to your person, it also does so for the
contents of the file you have signed. the math behind how this works
is very interesting and if you're interested, a more thorough
introduction can [be found on
wikipedia](http://en.wikipedia.org/wiki/Digital_signature).

unfortunately, behind a computer and whole internet, it is difficult
to know if a signature actually belongs to the person who claims it.

#### trust

one of the more difficult issues of dealing with cryptographic
identities is knowing if they actually are who they claim to be. this
requires a level of trust. an example of this trust is how we use ssl
keys. in most browsers, when you visit an https page, the addressbar
will turn green and a little secure lock icon shows up. when you click
the lock it will show details of a certificate issued by some
certificate authority.

which gpg, there is no central authority. instead, there is a web of
trust that is used, and over the years a method has been developed to
"build" a web of trust in the form of keysigning parties.

##### keysigning

the primary method of building a web of trust is by keysigning. this
is done by taking someones public key, then digitally signing it. your
signature to their key says to all others who download it that you
have met with the owner and you have personally verified that this key
belongs to him.

once this is done enough times, a small web of trust is created. if a
key has many signatures, we then can be reasonaly sure that this key indeed
belongs to that person as so many people have said they have verified
it.

---------------------------------------------------------------------

### how to use it

we have not talked about what keys are created and how they are used.
before we create them, it is useful to know what is created. as can be
seen in the intro, digital signatures are a very important, if not, the
most important, aspect of gnupg. you will create a signing key and
this key you will use to sign everything, it is also used to sign
other keys including other keys you own---these are called subkeys.

keeping your primary signing key is very important, as such it should
be backed up and kept somewhere safe. i will provide a method using
subkeys so that your primary key will stay safe on a usb flash drive.

throughout the rest of this guide, `/mnt/usb/` will refer to your flash
drive and `~/` will refer to your home directory.

#### creating your keys

first step is creating your keys. we will create our primary signing
key, then we will create two subkeys: the encryption key, and a second
signing key. these subkeys can be exported to any of the computers you
use. the benefit of using subkeys is that if any of them become
compromised, we can revoke them and create new subkeys under our
primary signing key. this has the benefit of not having to start a new
web of trust and having to redo all the keysigning.

at the command line, enter

    gpg --gen-key

when asked what kind of key you want to use, select either (1) or (2),
which should be `RSA and RSA` or `DSA and Elgamal`. which one you
choose is up to personal preference, but i chose `RSA and RSA`. the
next question will ask you what keysize you want, i have chosen
`4096`. next, you are asked when you want your your key to expire, i
put mine to expire at `2y`, or 2 years. the benefit of having an
expiration date is that if you lose the key, it will automatically
become invalid after 2 years. you always have the option to extend the
expiration date, so if there is 1 day left, you can set it to expire
after another 2 years.

afterwards, you provide your name and email address. you are then
asked if you are okay with the information you have entered. take this
moment to fix it. then select (O)kay.

after you key gen finishes
