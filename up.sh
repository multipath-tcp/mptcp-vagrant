vagrant up
echo "Will setup masquerading. Sudo might ask your password..."
sudo iptables -t nat -A POSTROUTING -s 192.168.33.0/24 -j MASQUERADE

cat <<EOF
#######################################################################

Things should be set up for you to test MPTCP from the virtual machine.
To log in, just issue the command
  vagrant ssh
To validate that MPTCP is working from inside the vm, issue
  curl www.multipath-tcp.org

You should get a joyful message announcing you are using MPTCP.

You can now become root with 
  sudo su

and manage this debian virtual machine.

#######################################################################
EOF

