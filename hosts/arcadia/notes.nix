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
      quarto
      strip-ansi
    ];
    serviceConfig = {
      User = "root";
      Group = "root";
      ExecStart = "${static_notes_script}/bin/generate-static-notes.py /var/lib/syncthing/SYNC_STUFF/notes/zk/notes /tmp/notes";
      Restart = "on-failure";
      Environment = [
        "NO_COLOR=1"
        "PYTHON_UNBUFFERED=1"
        "HOME=/tmp/.quarto"
        "XDG_CACHE_HOME=/tmp/.quarto/cache"
      ];
    };
  };
}
