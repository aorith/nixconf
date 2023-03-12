#!/usr/bin/env bash
cd "$(dirname -- "$0")" || exit 1

command -v flatpak || exit 1
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

if [[ ! -h "$HOME/.local/share/fonts" ]]; then
	mkdir -p "$HOME/.local/share"
	ln -s "/run/current-system/sw/share/X11/fonts" "$HOME/.local/share/fonts"
fi
flatpak --user override --filesystem=$HOME/.local/share/fonts || true
flatpak --user override --filesystem=$HOME/.icons || true

while read -r app; do
	flatpak install --or-update --assumeyes "$app" || exit 1
done < pkgs.txt
