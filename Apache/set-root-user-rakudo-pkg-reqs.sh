#!/usr/bin/env bash

RMODS="
Text::Utils
"

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
  echo "  Also installs the following Raku modules for root"
  echo "    Text::Utils"
  echo
  echo "  (This script must be executed as the root user.)"
  echo
  exit
fi

if [[ $UID -ne 0 ]] ; then
  echo "User '$USER' is not the root user...exiting without installation."
  exit
fi

ln -sf /opt/rakudo-pkg/bin/rakudo       /usr/local/bin/rakudo
ln -sf /opt/rakudo-pkg/bin/raku         /usr/local/bin/raku
ln -sf /opt/rakudo-pkg/bin/perl6        /usr/local/bin/perl6
ln -sf /opt/rakudo-pkg/var/zef/bin/zef  /usr/local/bin/zef

for f in $RMODS
do
    echo "Installing Raku module '$f'"
    /usr/local/bin/zef install $f
done
