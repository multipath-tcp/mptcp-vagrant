#!/bin/bash

start=$(date)

help() {
  cat <<-EOF
$(basename $0) [--config /path/to/kernel.config|--sources /path/to/kernel/sources|--help]
  --config : kernel config to use when compiling kernel
  --sources: kernel sources to use to compile kernel
  --help   : this help
EOF
}


# Handle options, which will override defaults from etc/settings.sh
CONFIG=""
SOURCES=""
while :; do
	case $1 in
	--help)
		help
		exit
		;;
	--config)
                if [[ -f $2 ]] ; then
			CONFIG=$2
			shift 2
                else
			echo "Config file not found"
			exit
		fi
		;;
	--sources)
		if [[ -d $2 ]] ; then
			SOURCES=$2
			shift 2
		else
			echo "Kernel sources not found"
		fi
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

# load libs and settings
my_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


. $my_dir/../etc/settings.sh
. $my_dir/../lib/functions.sh

# override default settings if passed as options to the script
[[ ! -z $SOURCES ]] && kernel_sources=$SOURCES
[[ ! -z $CONFIG  ]] && kernel_config=$CONFIG

# timestamp used in kernel version and appended to backup copy of existing kernel config
ts=$(date +%s)

# check presence of source and config
[[ -d $kernel_sources ]] || { echo "Kernel sources not found at $kernel_sources" && exit 1; }
[[ -f $kernel_config  ]] || { echo "Kernel config not found at $kernel_config" && exit 2; }

# copy config file if needed
if [[ $kernel_config != $kernel_sources/.config ]] ; then
  mv $kernel_sources/.config $kernel_sources/config.backup.$(date +%Y-%m-%d:%H:%M:%S)
  cp $kernel_config $kernel_sources/.config
fi


# build and copy to shared folder
(cd $kernel_sources && fakeroot make-kpkg --initrd --append-to-version "-$ts" kernel-image)
if [[ $? != "0" ]] ; then
  echo "Compilation failed"
  exit 3
fi

# try installing
#cp $kernel_sources/../*$ts* $my_dir/guest-data/to_install
#vagrant status | grep default | grep running > dev/null
#if [[ $? -gt 0 ]] ; then
#  # start the vm so we can copy kernel to it
#  vagrant up
#fi
#vagrant ssh -c dpkg -i /guest-data/to_install/linux-image*$ts*.deb
install_kernel $kernel_sources/../*$ts*

restart_vm


echo "Installed kernel with timestamp $ts:"
ls $kernel_sources/../*$ts*
echo "Started at $start and ended at $(date)"
