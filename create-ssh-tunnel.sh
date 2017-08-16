#!/bin/bash

# run to establish an ssh tunnel to run apps on a Debian-based host

# to enter, use a browser and navigate to:
#    https://localhost:${LOCALPORT}

REMOTEPORT=15000
LOCALPORT=10000
if [[ -z "$1" ]] ; then
  echo "Usage: $0 <host> <ssh user>"
  echo
  echo "Runs an ssh tunnel to the remote host."
  echo "Then use a browser to navigate to 'https://localhost:${LOCALPORT}'"
  echo
  exit
fi

# the source for this file is in:
#   /usr/local/git-repos/github/config-scripts/

HOST=$1
USR=$2

`ssh -L ${REMOTEPORT}15000:localhost:${LOCALPORT} "$USR"\@"$HOST"`
