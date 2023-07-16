{...}: {
  services.flatpak.enable = true;

  systemd.timers."check-for-flatpak-updates" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "5m";
      Unit = "check-for-flatpak-updates.service";
    };
  };

  systemd.services."check-for-flatpak-updates" = {
    environment = {
      DISPLAY = ":0";
      DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/1000/bus";
    };
    script = ''
      export PATH="/home/aorith/.nix-profile/bin:/run/current-system/sw/bin:$PATH"
      updates=()
      for n in $(flatpak remote-ls --updates); do
          updates+=("$n")
      done

      if ((''${#updates} > 0)); then
          notify-send -i /run/current-system/sw/share/icons/HighContrast/32x32/apps/system-software-update.png "Flatpak updates available: ''${updates[*]}"
          # flatpak update --assumeyes --noninteractive
      fi
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "aorith";
    };
  };
}
