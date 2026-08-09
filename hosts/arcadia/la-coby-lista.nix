{ pkgs, inputs, ... }:
let
  coby-lista = pkgs.buildGoModule {
    pname = "coby-lista";
    version = "unstable";
    src = inputs.la-coby-lista;
    vendorHash = "sha256-5WaCZ29wuU/aP05IBHTM0WhELYrYoerGlIS3QxoXL5o=";
  };

  runScript = pkgs.writeShellScript "coby-lista-start" ''
    set -eu
    token=$(head -n1 /etc/coby-lista-token.txt)
    exec ${coby-lista}/bin/coby-lista -port 8754 -token "$token" -db /var/lib/syncthing/SYNC_STUFF/coby-lista/coby.db
  '';
in
{
  systemd.services.coby-lista = {
    description = "coby-lista";
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
