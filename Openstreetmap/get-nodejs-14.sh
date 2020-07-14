#!/bin/bash

if [[ -z $1 ]] ; then
    echo "Usage: $0 go"
    echo
    echo "Run, as root, to download and install nodejs v14.x"
    echo 
    echo "See github.com/nodesource/distributions"
    echo
    exit
fi

curl -sL https://deb.nodesource.com/setup_v14.x | bash -
apt-get install nodejs
