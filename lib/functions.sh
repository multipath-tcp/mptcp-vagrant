base_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"

install_kernel() {
  # $1 is path on build host
  kernel=$1
  # this is the path from within the vbox
  in_vbox_path=/guest-data/kernel_to_install/$(basename $kernel)

  cp $kernel $base_dir/guest-data/kernel_to_install

  vagrant status | grep default | grep running > /dev/null
  if [[ $? -gt 0 ]] ; then
    # start the vm so we can copy kernel to it
    vagrant up
  fi
  vagrant rsync
  vagrant ssh --command "sudo dpkg -i $in_vbox_path"
  vagrant ssh --command "mv $in_vbox_path /guest-data/installed"
  mv $base_dir/guest-data/kernel_to_install/* $base_dir/guest-data/installed
}

restart_vm() {
  vagrant ssh -c "sudo reboot"
}

