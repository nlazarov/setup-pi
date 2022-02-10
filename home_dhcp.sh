#! /usr/bin/env bash
# set -x

apt install isc-dhcp-server

cat << dhcp_settings >> /etc/dhcp/dhcpd.conf
subnet 192.168.1.0 netmask 255.255.255.0 {
  range 192.168.1.5 192.168.1.159;
  option domain-name-servers 192.168.1.101, 1.1.1.1;
  option routers 192.168.1.1;
}
dhcp_settings

Interface=$(ip a | grep -v 127.0.0.1 | grep inet | awk '{ print $NF }')
sed -i "/INTERFACESv4=/c \INTERFACESv4=$Interface" /etc/defaults/isc-dhcp-server
