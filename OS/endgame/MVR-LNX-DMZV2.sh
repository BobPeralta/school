#!/bin/bash

#Set hostname
echo "MVR-LNX-DMZ" > "/etc/hostname";

#Disable firewall
sudo systemctl stop firewalld;
sudo systemctl disable firewalld;

#Setting up the network ports
#VLAN 80
echo -e "IPADDR='10.10.13.10/24'
NAME=''
BOOTPROTO='static'
STARTMODE='hotplug'
ZONE=''" > /etc/sysconfig/network/ifcfg-eth0;
sleep 1;
echo "Static route for eth0 set.";

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
echo -e "default 10.10.13.1 - eth0" > /etc/sysconfig/network/ifroute-eth0;
echo -e "default 10.10.13.1 - eth0" > /etc/sysconfig/network/ifroute-eth0.YaST2save;
sleep 1;
echo "IP routes set.";

#Restart networking
rcnetwork restart;

#Webserver
sudo zypper install -y nginx unzip;

sudo rm "srv/www/htdocs/*" -R;
sudo rm "/tmp/" -R;

wget https://github.com/BobPeralta/school/raw/main/OS/endgame/EndGame.zip -P /tmp;
sudo mv "/tmp/EndGame.zip" "/srv/www/htdocs";
sudo unzip "/srv/www/htdocs/EndGame.zip";

chmod 777 "/srv/www/htdocs";

systemctl enable nginx;

#Rsyslog
sudo zypper install -y rsyslog;
echo -e "*.* @10.11.13.11" > /etc/rsyslog.d/remote.conf

systemctl enable rsyslog;

#The end
sleep 1;
echo "Restarting";
sleep 1;
sudo reboot now;
exit;
