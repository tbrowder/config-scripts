#!/bin/bash

# run to establish an ssh tunnel to run Webmin on a Debian-based host

# to enter webmin, use a browser and navigate to:
#    https://localhost:10000

if [[ -z "$1" ]] ; then
  echo "Usage: $0 <host> <ssh user>"
  echo
  echo "Runs an ssh tunnel to the remote host."
  echo "Then use a browser to navigate to 'https://localhost:10000'"
  echo
  exit
fi

HOST=$1
USR=$2

ssh -L 15000:localhost:10000 "$USR"\@"$HOST" 
