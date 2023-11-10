#!/bin/bash

# Enable IP forwarding
sudo sysctl -w net.ipv4.ip_forward=1

# Configure iptables for NAT
sudo iptables -t nat -A POSTROUTING -o eth0 -s 10.5.0.0/16 -j MASQUERADE

# Install necessary packages
apt-get update
apt-get install -y iptables-persistent

# Save iptables rules
sudo sh -c "iptables-save > /etc/iptables/rules.v4"

# Enable the iptables-persistent service
sudo systemctl enable netfilter-persistent
sudo netfilter-persistent save
apt-get update && apt-get upgrade -y