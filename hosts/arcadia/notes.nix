{ pkgs, ... }:
let
  static_notes_script = pkgs.writeScriptBin "generate-static-notes.py" ''
    #!${pkgs.python3}/bin/python
    ${builtins.readFile ./generate-static-notes.py}
  '';
in
{
  systemd.services."notes-static" = {
    description = "Static Notes";
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [
      pandoc
    ];
    serviceConfig = {
      User = "syncthing";
      Group = "syncthing";
      ExecStart = "${static_notes_script}/bin/generate-static-notes.py /var/lib/syncthing/SYNC_STUFF/notes/zk/notes /tmp/notes";
      Restart = "on-failure";
      WorkingDirectory = "/var/lib/syncthing/SYNC_STUFF/notes/zk/notes";
    };
  };
}
