#!/bin/bash

# add mptcp repo if not present
if [[ ! -f /etc/apt/sources.list.d/multipath-tcp.list ]] ; then
    wget -q -O - http://multipath-tcp.org/mptcp.gpg.key | sudo apt-key add -
    cat >/etc/apt/sources.list.d/multipath-tcp.list <<EOF
deb http://multipath-tcp.org/repos/apt/debian trusty main
EOF
    apt-get update
    apt-get install -y linux-mptcp iproute2
fi


# install further debian packages found on shared fs
if ls /guest-data/to_install/*deb > /dev/null 2>&1; then
    for f in /guest-data/to_install/*deb  ;  do
        dpkg -i $f
        [[ -d /guest-data/installed/ ]] || mkdir /guest-data/installed/
        mv $f /guest-data/installed/
    done
fi

# set default route via the bridge, not the nat
ip route del default via 10.0.2.2
ip route add default via 192.168.33.1

#update grub settings to be able to switch kernels
sed -i -e "s/GRUB_DEFAULT=0/GRUB_DEFAULT=saved/" /etc/default/grub
update-grub
