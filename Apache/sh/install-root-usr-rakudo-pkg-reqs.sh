#!/usr/bin/env bash

RLINKS="
/usr/local/bin/rakudo
/usr/local/bin/raku
/usr/local/bin/perl6
"

RMODS="
Text::Utils
"

if [ -z "$1" ] ; then
  echo "Usage: $0 go"
  echo
  echo "For users of 'rakudo-pkg' raku installations, installs the"
  echo "the following sym links to Raku executables in '/usr/local/bin':"
  echo 

  for f in $RLINKS
  do
      echo "  $f"
  done

  echo
  echo "Also installs the following Raku modules for root"
  echo

  for f in $RMODS
  do
      echo "  $f"
  done

  echo
  echo "(This script must be executed as the root user.)"
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

for f in $RMODS
do
    echo "Installing Raku module '$f'"
    zef install $f
done
