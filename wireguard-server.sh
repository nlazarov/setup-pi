#! /usr/bin/env bash

wireguard_ip='10.0.0.1'

apt install -y wireguard iptables

function update_prop() {
    if [[ $(grep "$1=" "$3") == "" ]]; then
        echo "$1=$2" >> "$3"
    else
        sed -i "/$1=/c \\$1=$2" "$3"
    fi
}

update_prop "net.ipv4.ip_forward" "1" /etc/sysctl.conf
sysctl -p # apply the prop kernel param change above

private=$(wg genkey)
public=$(echo "$private" | wg pubkey)

cat << _conf > /etc/wireguard/wg0.conf
[Interface]
PrivateKey = $private
Address = $wireguard_ip/24
DNS = 127.0.0.1, 1.1.1.1
ListenPort = 36420

PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
_conf


systemctl enable --now wg-quick@.service

echo "Setup for wireguard is successful"
echo "Public key of the server is: '$public' at '$wireguard_ip'"
