#!/bin/bash

if [[ -z $1 ]] ; then
    echo "Usage: $0  s  |  w         # <== choose server or workstation"
    echo
    echo "Run as root to install nftables rules for servers or workstations"
    echo "  running Debian 10 Buster"
    echo
    echo "See 'README.nftables' for more information."
    echo
    exit
fi

aptitude update

aptitude install \
  nftables \
  fail2ban \
  apt-file

# end of aptitude install command list

if [[ $1 = 's' ]] ; then
    echo "Copying './nftables/nftables.conf.server' to '/etc/nftables.conf'"
    cp ./nftables/nftables.conf.server         /etc/nftables.conf
elif [[ $1 = 'w' ]] ; then
    echo "Copying './nftables/nftables.conf.workstation' to '/etc/nftables.conf'"
    cp ./nftables/nftables.conf.workstation   /etc/nftables.conf
else
    echo "FATAL: Unknown arg '$1'...aborting."
    exit
fi

nft -f /etc/nftables.conf
systemctl enable nftables
systemctl start nftables

# some useful commands:
#
#   sudo nft list ruleset

#========================================================================
# Instructions from:
#   https://ral-arturo.org/2017/05/05/debian-stretch-stable-nftables.html
# Rule sets from:
#   https://wiki.nftables.org/wiki-nftables/index.php/Simple_ruleset_for_a_server
#   https://wiki.nftables.org/wiki-nftables/index.php/Simple_ruleset_for_a_workstation
