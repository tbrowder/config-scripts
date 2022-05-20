#!/usr/bin/env bash

if [ -z "$1" ] ; then
  echo "Usage: $0 go"
  echo
  echo "  For users of 'rakudo-pkg' installations: installs"
  echo "    the 'raku' executable as a sym link to '/usr/local/raku'."
  echo
  echo "  (This must be executed as the root user.)"
  echo
  exit
fi

ln -sf /opt/rakudo-pkg/bin/raku         /usr/local/bin/raku
ln -sf /opt/rakudo-pkg/var/zef/bin/zef  /usr/local/bin/zef
