#!/bin/bash

# load libs and settings
my_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $my_dir/../etc/settings.sh
. $my_dir/../lib/functions.sh


netconsole_active=$(vagrant ssh -c "lsmod | grep netconsole")
if [[ -z $netconsole_active ]] ; then
  # load module
  echo           "sudo modprobe netconsole netconsole=@$eth1_ipv4/eth1,@$host_ipv4/" 
  vagrant ssh -c "sudo modprobe netconsole netconsole=@$eth1_ipv4/eth1,@$host_ipv4/" || { echo "Error loading module, exiting..." ; exit 1; }
else
  echo "netconsole module loaded, expecting it is with good options netconsole=@$eth1_ipv4/eth1,@$host_ipv4"
fi

echo "activating console on host:"
nc -u -l 6666 -k
