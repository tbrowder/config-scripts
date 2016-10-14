#!/bin/bash
# requires bash 3.2 (e.g., bash --version)
# the source for this file is in:
#   /usr/local/git-repos/github/config-scripts/
# run, as root, to set up rakudo on a Debian host

# don't forget the needed bash functions
. ./bash-funcs.sh
# requires bash 3.2 (e.g., bash --version)
check_bash_version

ARCH=star-2016.07.tar.gz
ARCHDIR=`get_archdir $ARCH`

echo "ARCH: '$ARCH'";
echo "ARCHDIR: '$ARCHDIR'";
debug_exit 3

INSTDIR=/usr/local/rakudo.d
BINDIR=$INSTDIR/bin
if [[ -z "$1" ]] ; then
    cat <<EOF
Usage: $0 go

As root, sets up a new Rakudo installation using a tgz release
  from <https://github.com/rakudo/star>.

Start in a clean directory with the desired Rakudo Star archive.

Internal variables (and current values) which may be changed as
desired:

  ARCH    - '$ARCH'
  INSTDIR - '$INSTDIR'
  BINDIR  - '$BINDIR'

EOF
  exit 0
fi

echo "Unpack '$ARCH'?"
get_approval

tar -xvzf $ARCH

echo "Configuring..."

# go to src dir
cd $ARCHDIR

# configure
CONF=""

echo "config cmd: '$CONF'"
echo "Configure?"
get_approval
$CONF

