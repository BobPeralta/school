#!/bin/bash

#Set hostname
echo "MVR-LNX-20" > "/etc/hostname";

#Disable firewall
sudo systemctl stop firewalld;
sudo systemctl disable firewalld;

#DHCP Relay
sudo zypper install -y dhcp-relay sysvinit-tools;
echo -e "DHCRELAY_INTERFACES=\"eth0 eth1\"
DHCRELAY_SERVERS=\"10.11.13.12\"
DHCRELAY_OPTIONS=\"\"" > /etc/sysconfig/dhcrelay;

sudo systemctl enable dhcrelay;
echo "DHCP-relay set.";

#Setting up the network ports
#VLAN 82
echo -e "IPADDR='10.12.13.20/24'
NAME=''
BOOTPROTO='static'
STARTMODE='hotplug'
ZONE=''" > /etc/sysconfig/network/ifcfg-eth0;
echo "Static route for eth0 set.";

#VLAN 83
echo -e "IPADDR='10.99.13.20/24'
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
echo -e "default 10.12.13.10 -eth0" > /etc/sysconfig/network/ifroute-eth0;
echo -e "default 10.12.13.10 -eth0" > /etc/sysconfig/network/ifroute-eth0.YaST2save;
echo "IP routes set.";

#The end
sudo reboot now;
exit;
