#!/usr/bin/env bash

if [[ -z $1 ]]; then
    echo "Usage: $0 go"
    echo
    echo "Downloads the latest Rakudo Star release archive."
    echo
    exit
fi

#curl -LJO https://rakudo.org/latest/star/source

ARCH=`ls -d rakudo-star-*gz`
ARCHDIR=${ARCH:0:19} # `ls rakudo-star-????.??*`
if [[ -f $ARCH ]] ; then
    echo "The latest Rakudo Star archive has been downloaded:"
    echo "See '$ARCH'"
    echo
    echo "Unpack it in this directory by executing:"
    echo
    echo "  \$ tar -txvzf $ARCH"
    echo
    echo "Change to the resulting subdirectory:"
    echo
    echo "  \$ cd $ARCHDIR"
    echo
    echo "Then execute:"
    echo
    echo "  \$ ../install-rakudo-star.sh"
    echo
    echo "for more instructions."
    echo
else
    echo "The latest Rakudo Star archive download has failed."
fi
