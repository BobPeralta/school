#!/bin/bash

#Set hostname
echo "MVR-LNX-10" > "/etc/hostname";

#Disable firewall
sudo systemctl stop firewalld;
sudo systemctl disable firewalld;

#Setting up the network ports
#VLAN 81
echo -e "IPADDR='10.11.13.10/24'
NAME=''
BOOTPROTO='static'
STARTMODE='hotplug'
ZONE=''" > /etc/sysconfig/network/ifcfg-eth0;
echo "Static route for eth0 set.";

#VLAN 82
echo -e "IPADDR='10.12.13.10/24'
NAME=''
BOOTPROTO='static'
STARTMODE='hotplug'
ZONE=''" > /etc/sysconfig/network/ifcfg-eth1;
echo "Static route for eth1 set.";

#Assigning a DNS
echo -e "nameserver 10.11.13.12" > /etc/resolv.conf;
echo "DNS set."

#Enabling ip forwarding
echo -e "net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 0
net.ipv6.conf.all.disable_ipv6 = 0" > /etc/sysctl.d/70-yast.conf;
echo "IP forwarding enabled.";

#IP route
echo -e "default 10.11.13.1 -eth0" > /etc/sysconfig/network/ifroute-eth0;
echo -e "default 10.11.13.1 -eth0" > /etc/sysconfig/network/ifroute-eth0.YaST2save;

echo -e "10.99.13.0/24 10.12.13.20 -eth1" > /etc/sysconfig/network/ifroute-eth1;
echo -e "10.99.13.0/24 10.12.13.20 -eth1" > /etc/sysconfig/network/ifroute-eth1.YaST2save;
echo "IP routes set.";

#The end
sudo reboot now;
exit;
