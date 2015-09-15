#!/usr/bin/env bash
# Removing NAT

for f in user_scripts/halt/* ; do 
	if [[ -x $f ]] ; then
		$f
	else
		echo "Not executable! Skipping $f"
	fi
done
