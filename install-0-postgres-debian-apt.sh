#!/usr/bin/env bash

# created based on instructions found here:
#   https://www.postgresql.org/download/linux/debian/

# run as root to install Postgresql on a Debian-based host with
# apt-get

VERSION=9.6
APTFIL=/etc/apt/sources.list.d/pgdg.list
if [[ -f $APTFIL ]] ; then
  echo "NOTE: Apt sources file '$APTFIL' exists, so this"
  echo "      script is not very useful.  Exiting...."
  echo
  exit
fi

if [[ -z "$1" ]] ; then
  echo "Usage: $0 8 | 9"
  echo
  echo "As root, this script will add Postgresql ${VERSION} apt sources for Debian"
  echo "  8 (jessie) or 9 (stretch), amd64."
  echo
  exit
fi

# test for root user
if [[ $(whoami) != "root" ]] ; then
  echo "FATAL: You must be the root user to run this script."
  echo
  exit
fi

# which os to install for?
DISTRO=
if [[ "$1" = "8" ]] ; then
    DISTRO=jessie
elif [[ "$1" = "9" ]] ; then
    DISTRO=stretch
else
  echo "FATAL: Unknown arg '$1'...exiting."
  echo
  exit
fi
echo "Installing Postgresql $VERSION apt sources for Debian $1 ($DISTRO)..."


# the source for this file is in:
#   /usr/local/git-repos/github/config-scripts/

# Procedures follow installation steps on the Postgresql site (www.postgresql.org).
# (Debian, binary, amd64)
KEYFIL=ACCC4CF8.asc
KEYLOC=https://www.postgresql.org/media/keys
wget -qO - $KEYLOC/$KEYFIL | apt-key add -

echo "deb http://apt.postgresql.org/pub/repos/apt/ ${DISTRO}-pgdg main" > $APTFIL
apt-get update

echo "Now install or check postgresql packages with script:"
echo "  'install-postgres-debian packages.sh'."
exit
