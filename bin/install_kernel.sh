#!/bin/bash

help() {
  cat <<-EOF
$(basename $0) [--deb /path/to/kernel.deb--help]
  --deb : debian package of kernel to install
  --reboot: reboot after install. Default: do not reboot
  --help   : this help
EOF
}

# by default do not reboot after install
REBOOT=false
while :; do
	case $1 in
	--help)
		help
		exit
		;;
	--deb)
                if [[ -f $2 ]] ; then
			kernel_package=$2
			shift 2
                else
			echo "Kernel package not found... Exiting"
			exit
		fi
		;;
        --reboot)
		REBOOT=true
		shift
		;;
	-?*)
		printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
		exit
		;;
	*)
		break
		;;
	esac
done

my_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $my_dir/../lib/functions.sh

[[ -z $kernel_package ]] && $0 --help && exit

install_kernel $kernel_package

#reboot only if requested
if [[ $REBOOT == true ]] ; then
  restart_vm
fi
