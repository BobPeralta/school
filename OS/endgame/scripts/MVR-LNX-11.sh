#!/bin/bash

#Set hostname
echo "MVR-LNX-11" > "/etc/hostname";

#Disable firewall
sudo systemctl stop firewalld;
sudo systemctl disable firewalld;

#Setting up the network ports
#VLAN 81
echo -e "IPADDR='10.11.13.11/24'
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
echo -e "default 10.11.13.10 -eth0" > /etc/sysconfig/network/ifroute-eth0;
echo -e "default 10.11.13.10 -eth0" > /etc/sysconfig/network/ifroute-eth0.YaST2save;
sleep 1;
echo "IP routes set.";

#Restart networking
rcnetwork restart;

#Rsyslog (https://techviewleo.com/configure-central-rsyslog-logging-server-on-opensuse/)
sudo zypper install -y rsyslog;
echo -e "#TCP
module(load=\"imtcp\")
input(type=\"imtcp\" port=\"514\" ruleset=\"RemoteRule\")

#UDP
module(load=\"imudp\")
input(type=\"imudp\" port=\"514\" ruleset=\"RemoteRule\")

#Template
\$template RemoteLogs,\"/logs/%HOSTNAME%/%PROGRAMNAME%.log\"
ruleset(name=\"RemoteRule\"){
action(type=\"omfile\" dynafile=\"RemoteLogs\")
}
" > /etc/rsyslog.d/logs.conf;^

systemctl enable rsyslog;

sudo mkdir /logs;
sudo chmod -R 777 /logs;

sleep 1;
echo "Syslog is set.";

#The end
sleep 1;
echo "Restarting";
sleep 1;
sudo reboot now;
exit;