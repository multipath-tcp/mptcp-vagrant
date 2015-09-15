#!/bin/bash
# Setting up NAT

for f in user_scripts/up/* ; do 
	if [[ -x $f ]] ; then
		$f
	else
		echo "Skipping $f"
	fi
done
