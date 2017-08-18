#!/bin/bash

# this dir is normally owned by root and used site-wide:
PREFIX=/usr/local/rakudo.d
#   user: Configure.pl ...
#   root: make install-instdir

if [[ -z "$1" ]] ; then
    echo "Usage: $0 go"
    echo
    echo "As the root user, this will configure rakudo."
    echo "  for installation into '$PREFIX'."
    echo
    echo "As root, cd to the source directory and execute:"
    echo
    echo "  # make"
    echo "  # make rakudo-test"
    echo
    echo "For more thorough, but longer, testing run:"
    echo
    echo "  # make rakudo-spectest   # <= expect 24 min or more "
    echo "  # make modules-test      # <= expect 11 min or more"
    echo
    echo "Finally, install into '$PREFIX' by running:"
    echo
    echo "  # make install           # <= expect 6 min or more"
    echo
    exit
fi

# must remove old binaries and libs

SUBDIRS="
bin
include
lib
share/nqp
share/pkgconfig
"

echo

RM=
for subdir in $SUBDIRS
do
    if [[ -d "$PREFIX/$subdir" ]] ; then
	if [[ -z $RM ]] ; then
	    echo "WARNING: Found one or more existing subdirectories to remove:"
	    echo
	    RM=y
	fi
	echo "  $PREFIX/$subdir"
    fi
done

if [[ -n $RM ]] ; then
    echo
    echo "FATAL:    The above listed existing subdirectories in '$PREFIX'"
    echo "           must be removed before continuing."
    exit
fi

perl Configure.pl --gen-moar --prefix=$PREFIX
