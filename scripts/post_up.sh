#!/bin/bash
# Setting up NAT

echo "Will setup masquerading. Sudo might ask your password..."
sudo iptables -t nat -A POSTROUTING -s 192.168.33.0/24 -j MASQUERADE

for f in user_scripts/up/* ; do 
	if [[ -x $f ]] ; then
		$f
	else
		echo "Skipping $f"
	fi
done
