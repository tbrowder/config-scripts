#!/bin/bash

# run as root to install Webmin on a Debian-based host

if [[ -z "$1" ]] ; then
  echo "Usage: $0 go"
  echo
  echo "As root, this script will install Webmin."
  echo
  exit
fi

# the source for this file is in:
#   /usr/local/git-repos/github/config-scripts/

# Procedures follow installation steps on the Webmin site (webmin.com).
# Note that 'sarge' is still correct as of jessie (Debian 8):
sh -c 'echo \
  "deb http://download.webmin.com/download/repository sarge contrib" \
    > /etc/apt/sources.list.d/webmin.list'
wget -qO - http://www.webmin.com/jcameron-key.asc | apt-key add -
apt-get update
apt-get install webmin
