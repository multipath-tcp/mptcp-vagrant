#!/bin/bash
set -x

echo "port up nat"
uname_str=$(uname)

echo "==> Enabling IP Masquerading"
if [[ "$uname_str" == "Linux" ]]; then
	sudo iptables -t nat -A POSTROUTING -s 192.168.33.0/24 -j MASQUERADE
elif [[ "$uname_str" == "Darwin" ]]; then
	echo "nat on en0 from 192.168.33.0/24 to any -> en0" | sudo pfctl -ef - >/dev/null 2>&1; 
else
	echo "FAILED! Host OS unknown"
fi

