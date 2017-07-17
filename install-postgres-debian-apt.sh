#!/bin/bash

# run as root to install Postgresql on a Debian-based host with apt-get

VERSION=9.6
APTFIL=/etc/apt/sources.list.d/pgdg.list
if [[ -e $APTFIL ]] ; then
  echo "NOTE: Apt sources file '$APTFIL' exists, so this"
  echo "      script is not very useful.  Exiting...."
  echo
  exit
fi

if [[ -z "$1" ]] ; then
  echo "Usage: $0 8 | 9"
  echo
  echo "As root, this script will install Postgresql $(VERSION) for Debian"
  echo "  8 (jessie) or 9 (atretch), amd64."
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
if [[ "$1" = "8"]] ; then
    DISTRO=jessie
elif [[ "$1" = "9"]] ; then
    DISTRO=stretch
else
  echo "FATAL: Unknown arg '$1'...exiting."
  echo
  exit
fi
echo "Installing Postgresql $VERSION for Debian $1 ($DISTRO)..."


# the source for this file is in:
#   /usr/local/git-repos/github/config-scripts/

# Procedures follow installation steps on the Postgresql site (www.postgresql.org).
# (Debian, binary, amd64)
KEYFIL=ACCC4CF8.asc
KEYLOC=https://www.postgresql.org/media/keys
wget -qO - $KEYLOC/$KEYFIL | apt-key add -
rm $KEYFIL

echo "deb http://apt.postgresql.org/pub/repos/apt/ $(DISTRO)-pgdg main" > $APTFIL
apt-get update

# install most all the packages
# -----------------------------
# install these
#   postgresql-9.6 - core database server
#   postgresql-client-9.6 - client libraries and client binaries
#   postgresql-contrib-9.6 - additional supplied modules
#   pgadmin3 - pgAdmin III graphical administration utility
# don't normally install these:
#   libpq-dev - libraries and headers for C language frontend development
#   postgresql-server-dev-9.6 - libraries and headers for C language backend development

apt-get install postgresql-$(VERSION)
postgresql-client-$(VERSION)
postgresql-contrib-$(VERSION)
pgadmin3
