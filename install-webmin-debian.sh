#!/bin/bash

if [[ -z "$1" ]] ; then
  echo "Usage: $0 go"
  echo
  echo "As root, this script will install Webmin."
  echo
  exit
fi

# run as root to install Webmin on a Debian-based host

# procedures follow installation steps on the Webmin site (webmin.com)

sh -c 'echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list'
wget -gO - http://www.webmin.com/jcameron-key.asc | apt-key add -
apt-get update
apt-get install webmin
 
