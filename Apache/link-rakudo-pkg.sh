#!/usr/bin/env bash

if [ -z "$1" ] ; then
  echo "Usage: $0 go"
  echo
  echo "  For users of 'rakudo-pkg' raku installations, installs the"
  echo "  the following executables as sym links in '/usr/local/bin':"
  echo "    raku"
  echo "    rakudo"
  echo "    perl6"
  echo "    zef"
  echo
  echo "  (This script must be executed as the root user.)"
  echo
  exit
fi

ln -sf /opt/rakudo-pkg/bin/rakudo       /usr/local/bin/rakudo
ln -sf /opt/rakudo-pkg/bin/raku         /usr/local/bin/raku
ln -sf /opt/rakudo-pkg/bin/perl6        /usr/local/bin/perl6
ln -sf /opt/rakudo-pkg/var/zef/bin/zef  /usr/local/bin/zef
