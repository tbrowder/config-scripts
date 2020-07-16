#!/bin/bash

if [[ -z $1 ]] ; then
    echo "Usage: $0 go"
    echo
    echo "Run, as root, to download and install nodejs LTS (v12)"
    echo 
    echo "See github.com/nodesource/distributions"
    echo
    exit
fi

#curl -o setup_lts.x -sL https://deb.nodesource.com/setup_lts.x 
#apt-get install nodejs
curl -sL https://deb.nodesource.com/setup_lts.x | bash -

