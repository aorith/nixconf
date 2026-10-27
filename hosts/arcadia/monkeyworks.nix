{ pkgs, inputs, ... }:
let
  monkeyworks = pkgs.buildGoModule {
    pname = "monkeyworks";
    version = "unstable";

    src = builtins.fetchGit {
      url = "file:///home/aorith/git/monkeyworks";
      ref = "master";
      rev = "fb2b36edd58450c724c02178e9d920e4033e92b4";
    };

    vendorHash = "sha256-lWVua+XHU33Fc9GzRPrHN82OHlGTPxQvkV8BD+tbx4U=";
  };

  runScript = pkgs.writeShellScript "monkeyworks-start" ''
    set -eu
    export TZ=Europe/Madrid
    export DB_PATH=/var/lib/syncthing/SYNC_STUFF/monkeyworks/monkeyworks.db
    export ADDR=127.0.0.1:8755
    exec ${monkeyworks}/bin/monkeyworks
  '';
in
{
  systemd.services.monkeyworks = {
    description = "monkeyworks";
    wantedBy = [ "multi-user.target" ];
    after = [
      "network.target"
      "syncthing.service"
    ];
    unitConfig = {
      ConditionPathExists = "/var/lib/syncthing/luks-mounted";
    };
    serviceConfig = {
      ExecStart = runScript;
      User = "syncthing";
      Group = "syncthing";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
