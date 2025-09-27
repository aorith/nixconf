#!/bin/sh
set -xe
sudo cryptsetup luksOpen /root/syncthing.img syncthingdev || true
sudo mount -t auto /dev/mapper/syncthingdev /var/lib/syncthing
df -h /var/lib/syncthing
