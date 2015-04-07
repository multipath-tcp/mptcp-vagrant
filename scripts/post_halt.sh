# Removing NAT

echo "Will remove masquerading. Sudo might ask your password..."
sudo iptables -t nat -D POSTROUTING -s 192.168.33.0/24 -j MASQUERADE

