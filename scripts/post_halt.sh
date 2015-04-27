#!/usr/bin/env bash
# Removing NAT

echo "Will remove masquerading. Sudo might ask your password..."
sudo iptables -t nat -D POSTROUTING -s 192.168.33.0/24 -j MASQUERADE

for f in user_scripts/halt/* ; do 
	if [[ -x $f ]] ; then
		$f
	else
		echo "Not executable! Skipping $f"
	fi
done
