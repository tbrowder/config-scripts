#!/bin/bash

# set the latest known or desirable version
LATEST=2017.07


SRCDIR="https://rakudo.perl6.org/downloads/star"
if [[ -z $1 ]] ; then
    echo "Usage: $0 go | <version> [v]"
    echo
    echo "Downloads Rakudo Star source from site '$SRCDIR'."
    echo
    echo "The 'go' uses version '$LATEST', or you can choose another version."
    echo
    exit
fi

if [[ $1 =~ "g" ]] ; then
    VER=$LATEST
    #echo "first arg ($1) is 'go'"
else
    VER=$1
    #echo "first arg ($1) should be a version"
fi
#echo "debug exit"; exit

SNAME=rakudo-star-$VER.tar.gz

SRC="$SRCDIR/$SNAME"

echo "Downloading src file '$SNAME'..."
curl $SRC -o $SNAME

echo
echo "Now edit and use config script 'rakudo-star-config.sh'."
