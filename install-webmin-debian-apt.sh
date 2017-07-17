#!/bin/bash

# run as root to install Webmin on a Debian-based host with apt-get

APTFIL=/etc/apt/sources.list.d/webmin.list
if [[ -f $APTFIL ]] ; then
  echo "NOTE: Apt sources file '$APTFIL' exists, so this"
  echo "      script is not very useful.  Exiting...."
  echo
  exit
fi

if [[ -z "$1" ]] ; then
  echo "Usage: $0 go"
  echo
  echo "As root, this script will install Webmin."
  echo
  exit
fi

# the source for this file is in:
#   /usr/local/git-repos/github/config-scripts/

# Procedures follow installation steps on the Webmin doc site (http://doxfer.webmin.com/Webmin/Installation).
# Note that 'sarge' is still correct as of jessie (Debian 8):
KEYFIL=jcameron-key.asc
KEYLOC=http://www.webmin.com
wget -qO - $KEYLOC/$KEYFIL | apt-key add -
rm $KEYFIL

echo "deb http://download.webmin.com/download/repository sarge contrib" > $APTFIL

apt-get update
apt-get install webmin

echo "======================================================================"
echo "See post-installation steps in script: 'config-webmin-post-install.sh'"
echo "======================================================================"
