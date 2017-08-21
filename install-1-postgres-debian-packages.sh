#!/usr/bin/env bash

# created based on instructions found here:
#   https://www.postgresql.org/download/linux/debian/

# run as root to install or update Postgresql on a Debian-based host

if [[ -z "$1" ]] ; then
  echo "Usage: go"
  echo
  echo "As root, this script will install Postgresql ${VERSION} for Debian"
  echo "  amd64."
  echo
  exit
fi

# test for root user
if [[ $(whoami) != "root" ]] ; then
  echo "FATAL: You must be the root user to run this script."
  echo
  exit
fi

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

apt-get update
apt-get install postgresql-$VERSION
apt-get install postgresql-client-$VERSION
apt-get install postgresql-contrib-$VERSION
apt-get install pgadmin3
