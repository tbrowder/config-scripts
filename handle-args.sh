#!/usr/bin/env bash

if [ -z "$1" ] ; then
  echo "Usage: $0 go"
  echo
  echo "  Configures Subversion (last tested on version 1.10.0)."
  exit
fi


# make -j8 check      # < ?? min on dedi2 (UNABLE ON DEDI2!!??)
#   OR
# make -j4 check      # < 66 min on dedi4

# make install
