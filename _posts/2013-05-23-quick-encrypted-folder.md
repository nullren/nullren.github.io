---
layout: post
title: "quick encrypted folder"
category: 
tags: [win, linux, dmcrypt, crypto, rawr]
---

i wanted an encrypted folder that i could throw around like a file to
easily backup in different ways. `encfs` and `ecryptfs` are usually
better solutions for most people. i wanted one file for my entire
directory, so this worked out okay.

### set up

first step, create a file suitably large to hold your filesystem

    # dd if=/dev/zero of=derp bs=1M count=10

now mount it with `losetup` (`modprobe loop` if not loaded) so that we
cna use it as a block device

    # losetup -f
    /dev/loop0

this just tells me what the next available loop device is.

    # losetup /dev/loop0 derp 

`/dev/loop0` is now like a normal block device. so lets set up
dmcrypt on it (`modprobe dm_crypt` if this is not loaded).

follow the instructions, the defaults should be okay but there are
more options you can give it. this command will set up a password used
to protect the file.

    # cryptsetup luksFormat /dev/loop0

now open it.

    # cryptsetup luksOpen /dev/loop0 encstore

enter your password, now we have something like a normal disk device
that we can format using whatever fs we want.

    # mkfs.ext3 /dev/mapper/encstore

this sets up the encrypted folder. from here i can mount it or
whatever.

### mounting

if we had set up a file `derp` to be an encrypted folder like in the
set up, this is how i would mount it.

    # losetup -f
    /dev/loop0
    # losetup /dev/loop0 derp
    # cryptsetup luksOpen /dev/loop0 encstore
    # mount /dev/mapper/encstore /mnt/sec

now i can put files in `/mnt/sec` and feel okay about it.

### unmounting

this is how i unmount it

    # umount /mnt/sec
    # cryptsetup luksClose encstore
    # losetup -d /dev/loop0

now i can copy `derp` to whatever disk i want, write it to a dvd, save
to a usb, email it, whatever.
