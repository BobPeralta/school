#!/bin/bash

#Set hostname
echo "MVR-LNX-31" > "/etc/hostname";

#Disable firewall
sudo systemctl stop firewalld;
sudo systemctl disable firewalld;

#Assigning a DNS
echo -e "nameserver 10.11.13.12" > /tmp/resolv.conf;
sudo mv /tmp/resolv.conf /etc/resolv.conf;
echo "DNS set."

#Enabling ip forwarding
echo -e "net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 0
net.ipv6.conf.all.disable_ipv6 = 0" > /etc/sysctl.d/70-yast.conf;
echo "IP forwarding enabled.";

#IP route
echo -e "default 10.99.13.20 -eth0" > /etc/sysconfig/network/ifroute-eth0;
echo -e "default 10.99.13.20 -eth0" > /etc/sysconfig/network/ifroute-eth0.YaST2save;

#The end
sudo reboot now;
exit;
