#!/bin/bash

if [[ -z $1 ]] ; then
    echo "Usage: $0 go"
    echo
    echo "Run as root to install Openstreetmap prereq packages for Debian 10 Buster amd64"
    echo
    exit
fi

aptitude update

aptitude install \
  postgis

# end of command list
