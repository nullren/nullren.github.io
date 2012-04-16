---
layout: post
title: "quick image upload thing"
category: 
tags: []
---
{% include JB/setup %}

# quick image uploader

here are a couple text files i use to do things. the first one is called
`imgscp` and this script takes an image and uploads it to my server.


    #!/bin/sh

    [ $# -lt 1 -a ! -f $1 ] && exit 1

    THING=$1
    SSHSTR="pompom"
    BLAH=$(md5sum "${THING}" | awk '{ print $1 }')

    if [ -f $THING ]; then
        scp "${THING}" "${SSHSTR}:scrots/${BLAH}.png"
    fi

    [ $? -ne 0 ] && (echo error && exit 1)

    IMGURL="http://omgren.com/s/${BLAH}.png"

    echo -n $IMGURL | xclip
    echo -n $IMGURL | xclip -selection c
    echo read $IMGURL into xclip
    notify-send -t 500 "$IMGURL"
    #browser "$IMGURL"


it needs to be fixed because right now it assumes everything is a png.
but, i call that script from another script that basically just runs
`scrot -s` and it is called `grab`.


    #!/bin/sh

    GRABDIR=/tmp
    UPLOADSCRIPT=imgscp

    COUNT=$(ls "${GRABDIR}"/screengrab-*.png 2>/dev/null | wc -l)
    ID=$(echo $COUNT+1 | bc)

    scrot -s "${GRABDIR}/screengrab-${ID}.png"

    #[ $# -lt 1 ] && exit 0

    echo -n hold on | xclip
    $UPLOADSCRIPT "${GRABDIR}/screengrab-${ID}.png" 


i'll add these to my bitbucket project called "pasta".
