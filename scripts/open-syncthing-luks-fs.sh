#!/usr/bin/env bash
set -xe

sudo cryptsetup luksOpen /root/syncthing.img syncthingdev || true
sudo mount -t auto /dev/mapper/syncthingdev /var/lib/syncthing
df -h /var/lib/syncthing

set +x
services=(syncthing coby-lista monkeyworks)
for s in "${services[@]}"; do
    echo "Starting $s ..."
    sudo systemctl start "$s".service
    sleep 3
    sudo systemctl is-active "$s".service
done
