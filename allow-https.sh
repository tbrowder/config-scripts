#!/usr/bin/env bash

# allow http/https traffic through the firewall

# must be run as root

iptables -A INPUT  -p tcp -m multiport --dport 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT 
iptables -A OUTPUT -p tcp -m multiport --sport 80,443 -m conntrack --ctstate ESTABLISHED -j ACCEPT 
