About
=====
This repo contains vagrant configurations to help you test Multipath TCP.

The setup enables you to test MPTCP from the virtual machine without requiring MPTCP 
support from the host.

Requirements
============
You need vagrant and virtualbox. Get it at http://www.vagrantup.com/downloads.html
and https://www.virtualbox.org/wiki/Downloads

You also need to have root access via sudo so the script can add NAT rules.
Currently onle Linux hosts with iptables are supported.

Using it
========

Get it and use it:

    git clone https://github.com/rbauduin/vagrant_mptcp.git
    ./up.sh

This will:

  * download a vagrant box
  * start the virtual machine
  * setup NAT

To validate all works as expected, issue this command:

    vagrant ssh -c "curl www.multipath-tcp.org"

The outpout should be message full of joy, congratulating you for your MPTCP capabilities!
  