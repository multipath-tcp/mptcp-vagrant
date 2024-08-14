echo "Setting up MPTCP..."

vagrant ssh client <<EOF
    # Sometimes the ip addresses aren't assigned by virtualbox, so do it manually
    sudo ip addr add 192.168.56.100/24 dev eth1
    sudo ip addr add 192.168.57.100/24 dev eth2
    sudo ip addr add 192.168.58.100/24 dev eth3

    # Configure MPTCP
    sudo sysctl net.mptcp.enabled=1
    sudo ip mptcp limits set subflow 9
    sudo ip mptcp limits set add_addr_accepted 9
    sudo ip mptcp endpoint add 192.168.57.100 dev eth2 subflow
    sudo ip mptcp endpoint add 192.168.58.100 dev eth3 subflow
EOF 2> /dev/null

vagrant ssh server <<EOF
    # Sometimes the ip addresses aren't assigned by virtualbox, so do it manually
    sudo ip addr add 192.168.56.101/24 dev eth1
    sudo ip addr add 192.168.57.101/24 dev eth2
    sudo ip addr add 192.168.58.101/24 dev eth3

    # Configure MPTCP
    sudo sysctl net.mptcp.enabled=1
    sudo ip mptcp limits set subflow 9
    sudo ip mptcp endpoint add 192.168.57.101 dev eth2 signal
    sudo ip mptcp endpoint add 192.168.58.101 dev eth3 signal
EOF 2> /dev/null

echo "Done setting up MPTCP..."