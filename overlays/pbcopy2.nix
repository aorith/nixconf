final: prev: let
  xsel = "${prev.pkgs.xsel}/bin/xsel";
in {
  pbcopy2 = prev.pkgs.writeShellScriptBin "pbcopy2" ''
    if [[ "$XDG_SESSION_TYPE" == "x11" ]]; then
        ${xsel} -i -p && ${xsel} -o -p | ${xsel} -i -b
    elif [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
        ${prev.pkgs.wl-clipboard}/bin/wl-copy
    else
        pbcopy
    fi
  '';
}
