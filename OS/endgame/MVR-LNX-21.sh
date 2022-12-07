#!/bin/bash

#Set hostname
echo "MVR-LNX-21" > "/etc/hostname";

#Disable firewall
sudo systemctl stop firewalld;
sudo systemctl disable firewalld;

#Assigning a DNS
echo -e "nameserver 10.11.13.12" > /tmp/resolv.conf;
sudo mv /tmp/resolv.conf /etc/resolv.conf;
sleep 1;
echo "DNS set."

#Enabling ip forwarding
echo -e "net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 0
net.ipv6.conf.all.disable_ipv6 = 0" > /etc/sysctl.d/70-yast.conf;
sleep 1;
echo "IP forwarding enabled.";

#IP route
echo -e "default 10.12.13.20 - eth0" > /etc/sysconfig/network/ifroute-eth0;
echo -e "default 10.12.13.20 - eth0" > /etc/sysconfig/network/ifroute-eth0.YaST2save;
sleep 1;
echo "IP routes set.";

#The end
sleep 1;
echo "Restarting";
sleep 1;
sudo reboot now;
exit;