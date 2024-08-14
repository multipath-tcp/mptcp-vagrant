echo "Setting up MPTCP..."

vagrant ssh client <<EOF
    # Sometimes the ip addresses aren't assigned by virtualbox, so do it manually
    sudo ip addr add 192.168.56.100/24 dev eth1 2> /dev/null
    sudo ip addr add 192.168.57.100/24 dev eth2 2> /dev/null
    sudo ip addr add 192.168.58.100/24 dev eth3 2> /dev/null

    # Configure MPTCP
    sudo sysctl net.mptcp.enabled=1
    sudo ip mptcp limits set subflow 8
    sudo ip mptcp limits set add_addr_accepted 8
    sudo ip mptcp endpoint add 192.168.57.100 dev eth2 subflow
    sudo ip mptcp endpoint add 192.168.58.100 dev eth3 subflow
EOF

vagrant ssh server <<EOF
    # Sometimes the ip addresses aren't assigned by virtualbox, so do it manually
    sudo ip addr add 192.168.56.101/24 dev eth1 2> /dev/null
    sudo ip addr add 192.168.57.101/24 dev eth2 2> /dev/null
    sudo ip addr add 192.168.58.101/24 dev eth3 2> /dev/null

    # Configure MPTCP
    sudo sysctl net.mptcp.enabled=1
    sudo ip mptcp limits set subflow 8
    sudo ip mptcp endpoint add 192.168.57.101 dev eth2 signal
    sudo ip mptcp endpoint add 192.168.58.101 dev eth3 signal
EOF

echo "Done setting up MPTCP..."