#!/usr/bin/env bash

if ! command -v nmcli >/dev/null 2>&1; then
    exit 0
fi

case $HOSTNAME in
trantor)
    if nmcli connection show br0 >/dev/null; then
        exit 0
    fi

    sudo nmcli conn delete 'br0'
    sudo nmcli conn delete 'bridge-br0'

    sudo nmcli con add ifname br0 type bridge ifname br0 con-name br0 stp no
    sudo nmcli con add type bridge-slave ifname enp8s0 master br0 con-name bridge-br0

    sudo nmcli connection modify br0 ipv4.addresses '10.255.255.7/24'
    sudo nmcli connection modify br0 ipv4.gateway '10.255.255.1'
    sudo nmcli connection modify br0 ipv4.dns '8.8.8.8,8.8.4.4'
    sudo nmcli connection modify br0 ipv4.dns-search 'iou.re'
    sudo nmcli connection modify br0 ipv4.method manual
    sudo nmcli connection modify br0 ipv6.method disabled

    sudo nmcli conn down 'Wired connection 1'

    sudo nmcli con up br0
    sudo nmcli con up bridge-br0

    nmcli connection show
    ;;
*)
    exit 0
    ;;
esac
