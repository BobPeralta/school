#!/bin/bash

#Set hostname
echo "MVR-LNX-20" > "/etc/hostname";

#Disable firewall
sudo systemctl stop firewalld;
sudo systemctl disable firewalld;

#Setting up the network ports
#VLAN 82
echo -e "IPADDR='10.12.13.20/24'
NAME=''
BOOTPROTO='static'
STARTMODE='hotplug'
ZONE=''" > /etc/sysconfig/network/ifcfg-eth0;
sleep 1;
echo "Static route for eth0 set.";

#VLAN 83
echo -e "IPADDR='10.99.13.20/24'
NAME=''
BOOTPROTO='static'
STARTMODE='hotplug'
ZONE=''" > /etc/sysconfig/network/ifcfg-eth1;
sleep 1;
echo "Static route for eth1 set.";

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
echo -e "default 10.12.13.10 -eth0" > /etc/sysconfig/network/ifroute-eth0;
echo -e "default 10.12.13.10 -eth0" > /etc/sysconfig/network/ifroute-eth0.YaST2save;
sleep 1;
echo "IP routes set.";

#Restart networking
rcnetwork restart;

#DHCP Relay
sudo zypper install -y dhcp-relay sysvinit-tools;
echo -e "DHCRELAY_INTERFACES=\"eth0 eth1\"
DHCRELAY_SERVERS=\"10.11.13.12\"
DHCRELAY_OPTIONS=\"\"" > /etc/sysconfig/dhcrelay;

sudo systemctl enable dhcrelay;
sleep 1;
echo "DHCP-relay set.";

#The end
sudo reboot now;
exit;