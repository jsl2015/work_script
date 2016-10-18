#!/bin/bash

iptables -F
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p icmp --icmp-type fragmentation-needed -j ACCEPT

#for ping&ssh&DNS&ntp:
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A INPUT -p tcp -s 61.161.85.122/24  --dport 22 -j  ACCEPT
iptables -A INPUT -p tcp -s 115.159.108.249  --dport 22 -j  ACCEPT
iptables -A INPUT -p tcp -s 104.224.136.154  --dport 22 -j  ACCEPT
iptables -A INPUT -p tcp --sport 53 -j ACCEPT
iptables -A INPUT -p udp --sport 53 -j ACCEPT
iptables -A INPUT -p udp --sport 123 -j ACCEPT
iptables -A INPUT -p udp --dport 123 -j ACCEPT

#for game:
iptables -A INPUT -p tcp -s 119.29.85.172/24 -j  ACCEPT
iptables -A INPUT -p tcp -s 10.0.0.0/8 -j  ACCEPT
iptables -A INPUT -p tcp -m multiport --dports 888:891,10050 -j  ACCEPT
iptables -A INPUT -p tcp -m multiport --dports 20011,20012,20132,886,887 -j ACCEPT
iptables -A INPUT -p tcp -s 61.161.85.122/24 -m multiport --dports 2126,3306:3311 -j ACCEPT

#others:
iptables -A INPUT -p tcp -j REJECT --reject-with tcp-reset

#save:
/etc/rc.d/init.d/iptables save
