#!/usr/bin/env bash
[[ $(id -u) != 0 ]] || exit 1
cd "$(dirname -- "$0")" || exit 1

if [[ ! -L "$HOME/Syncthing" ]]; then
    ln -s "$HOME/storage/tank/data/syncthing" "$HOME/Syncthing"
fi
sudo chown root:root -h "$HOME/Syncthing"

# Network manager
./nmcli-boostrap.sh

# Flatpak
if command -v flatpak >/dev/null 2>&1; then
    ./flatpak/install.sh
fi
