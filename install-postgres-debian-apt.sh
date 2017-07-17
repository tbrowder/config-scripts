#!/bin/bash

echo NOT READY YET
exit

# run as root to install Postgresql on a Debian-based host with apt-get

APTFIL=/etc/apt/sources.list.d/webmin.list
if [[ -e $APTFIL ]] ; then
  echo "NOTE: Apt sources file '$APTFIL' exists, so this"
  echo "      script is not very useful.  Exiting...."
  echo
  exit
fi

if [[ -z "$1" ]] ; then
  echo "Usage: $0 8 | 9"
  echo
  echo "As root, this script will install Postgresql for Debian"
  echo "  8 (jessie) or 9 (atretch), amd64."
  echo
  exit
fi

# test for root user
if [[ $(whoami) != "root" ]] ; then
  echo "FATAL: You must be the root user to run this script."
  echo
  exit
fi

# which os to install for?
if [[ "$1" = "8"]] ; then
  echo "Installing for Debian 8 (jessie)..."
elif [[ "$1" = "9"]] ; then
  echo "Installing for Debian 9 (stretch)..."
else
  echo "FATAL: Unknown arg '$1'...exiting."
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
