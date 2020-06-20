#!/bin/bash

if [[ -z $1 ]] ; then
    echo "Usage: $0 go"
    echo
    echo "Run as root to install nftables rules for servers running Debian 10 Buster"
    echo
    echo "See 'README.nftabels' for more information."
    echo
    exit
fi

aptitude update

aptitude install \
  nftables \
  fail2ban \
  apt-file

# end of aptitude install command list

cp /usr/share/doc/nftables/examples/syntax/workstation /etc/nftables.conf
nft -f /etc/nftables.conf
systenctl enable nftables

# some useful commands:
#
#   nft list ruleset

#========================================================================
# Instructions from:
#   https://ral-arturo.org/2017/05/05/debian-stretch-stable-nftables.html

Once installed, you can start using the nft command:

  # nft list ruleset

A good starting point is to copy a simple workstation firewall configuration:

  # cp /usr/share/doc/nftables/examples/syntax/workstation /etc/nftables.conf

And load it:

  # nft -f /etc/nftables.conf

Your nftables ruleset is now firewalling your network:

  # nft list ruleset
  table inet filter {
          chain input {
                  type filter hook input priority 0;
                  iif lo accept
                  ct state established,related accept
                  ip6 nexthdr icmpv6 icmpv6 type { nd-neighbor-solicit,  nd-router-advert, nd-neighbor-advert } accept
                  counter drop
          }
  }


Several examples can be found at /usr/share/doc/nftables/examples/.

A simple systemd service is included to load your ruleset at boot
time, which is disabled by default

  # systenctl enable nftables
