---
title: lenovo thinkpad x1 carbon touch bios update on linux
---

since this laptop does not come with an optical drive to use a cd, i
had to use flash. for some reason, the iso images provided by lenovo
cannot be written to usb drives like as has now become normal. so, we
must extract an image capable of such things.

first thing i needed was the actual bios update. the particular update
i used was `gruj11us.iso`. the file can be [found at
lenovo.com](http://support.lenovo.com/en_US/downloads/detail.page?DocID=DS039783).

the next thing i needed was to download the `geteltorito.pl` script.
at the time of writing, i used v0.5. it can be [found here along with
some other
info](http://userpages.uni-koblenz.de/~krienke/ftp/noarch/geteltorito/).

run the `geteltorito.pl` script on the `gruj11us.iso` image and save
the output which will be the image you'll use to put on the flash
drive.

    $ perl geteltorito.pl -o biosupdate.img gruj11us.iso
    $ dd if=biosupdate.img of=/dev/disk/by-id/usb-flash-drive:0 bs=512K

this was enough for me.

---------------------------------

originally, when looking around, i found outdated scripts that didn't
work very well. they did not produce a full image. so, here, i'm
providing links to the binaries and their sha1sums so that hopefully
people will not struggle with something that was actually pretty
simple.

```
7d356fc04a87250831540f1871fc323c60b7a655 [biosupdate.img](/bin/biosupdate.img)
65714e678c07158399c25c54db617dfca1ae8d92 [geteltorito.pl](/bin/geteltorito.pl)
fd13aa94bff82e6df9c6cefd8ad002af78958c8b [gruj11us.iso](/bin/gruj11us)
```

