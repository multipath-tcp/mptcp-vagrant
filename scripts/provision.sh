#!/bin/bash
set -x

# set default route via the bridge, not the nat
host_ipv4="192.168.33.1"

ip route del default via 10.0.2.2
ip route add default via $host_ipv4
