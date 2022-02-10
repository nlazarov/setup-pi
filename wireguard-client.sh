#! /usr/bin/env bash

client_number="${1?'Please, define client number to complete the ip 10.0.0.??/24'}"
private=$(wg genkey)
public=$(echo "$private" | wg pubkey)
wg_ip="10.0.0.$client_number"

root_dir=./

while getopts d: option
do
  case "$option"
    in
    d) root_dir="$OPTARG";;
    *) ;;
  esac
done

cat << _conf > "$root_dir"/wgo.conf
[Interface]
  PrivateKey = $private
  Address = $wg_ip/24
  ListenPort = 36420
  DNS = 10.0.0.1, 1.1.1.1

[Peer]
  PublicKey = U7kvf6KpbMh5r4MaiXrsnFQ5MgzGTl1DFBArYK+Rfzc=
  AllowedIPs = 0.0.0.0/0
  Endpoint = 94.156.169.244:36420
  PersistentKeepalive = 25
_conf

cat << _server_conf
[Peer]
  PublicKey = $public
  AllowedIPs = $wg_ip/32
_server_conf
