#!/bin/bash
set -x

echo "port halt nat"
uname_str=$(uname)

echo "==> Disabling IP Masquerading"
if [[ "$uname_str" == "Linux" ]]; then
	sudo iptables -t nat -D POSTROUTING -s 192.168.33.0/24 -j MASQUERADE
elif [[ "$uname_str" == "Darwin" ]]; then
	sudo pfctl -df /etc/pf.conf > /dev/null 2>&1;
else
	echo "FAILED! Host OS unknown"
fi


