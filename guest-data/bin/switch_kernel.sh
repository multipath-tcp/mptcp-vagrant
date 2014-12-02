#!/bin/bash

# by default switch kernel for one reboot only
GRUB_CMD=grub-reboot
# do not switch back to default config
RESET=false


help() {
  cat <<-EOF
$(basename $0) [--once|--default|--reset|--help]
  --once   : switch kernel for one reboot only
  --default: change default kernel
  --reset  : back to booting most recent kernel
  --reboot : reboot vm after running command
  --help   : this help
Options can be combined. If multiple options from the group --once,--default,--reset are set, the last takes precedence.
EOF
}


while :; do
	case $1 in
	--help)
		help
		exit
		;;
	--reboot)
		REBOOT=true
		shift
		;;
	--once)
		GRUB_CMD=grub-reboot
		shift
		;;
	--default)
		GRUB_CMD=grub-set-default
		shift
		;;
	--reset)
		GRUB_CMD=grub-set-default
		RESET=true
		shift;;
		
	-?*)
		printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
		exit
		;;
	*)
		break
		;;
	esac
done

    

if [[ $RESET == true ]] ; then
	sudo grub-set-default 0
else
	select k in $(egrep "menuentry.*Linux"  /boot/grub/grub.cfg | grep -v recovery | awk '{print $5}'); do echo ; echo "Switching once to kernel $k"; entry=$((($REPLY-1)*2)); sudo $GRUB_CMD "1>$entry" ; break; done
fi


if [[ $REBOOT == true ]]; then
	sudo reboot
fi
