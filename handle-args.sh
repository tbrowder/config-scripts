#!/usr/bin/env bash
if [ -z "$1" ] ; then
  echo "Usage: $0 <choice>"
  echo
  echo "  Choices:"
  echo "    a"
  echo "    b"
  exit
fi

if [[ "$1" = "a" ]] ; then
  echo "a"
elif [[ "$1" = "b" ]] ; then
  echo "b"
else 
  echo "FATAL: Unknown arg " $1
  exit
fi


