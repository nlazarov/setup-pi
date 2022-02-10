#! /usr/bin/env bash

key=${1?'Please, define the public key for the client'}
ip=${2?'Please, define the ip for the client'}

cat << _conf >> /etc/wireguard/wg0.conf

[Peer]
  PublicKey = $key
  AllowedIPs = $ip/32
_conf
