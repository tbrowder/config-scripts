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
  echo "For users of 'rakudo-pkg' raku installations, UNINSTALLS the"
  echo "the following executable sym links:"
  echo

  for f in $RLINKS
  do
      echo "  $f"
  done

  echo
  echo "Also UNINSTALLS the following Raku modules for root"
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
  echo "User '$USER' is not the root user...exiting without uninstalling anything."
  exit
fi

for f in $RMODS
do
    echo "UNINSTALLING Raku module '$f'"
    zef uinstall $f
done

rm -f /usr/local/bin/rakudo
rm -f /usr/local/bin/raku
rm -f /usr/local/bin/perl6
