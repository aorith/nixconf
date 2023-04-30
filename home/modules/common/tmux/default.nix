{pkgs, ...}: let
  tcdn_server_for_go = pkgs.stdenv.mkDerivation {
    name = "tcdn_server_for_go";
    src = ./bin/tcdn_server_for_go/.;
    buildInputs = [
      pkgs.go
    ];

    buildPhase = ''
      HOME="$(pwd -P)"
      export HOME
      go build -o tcdn_server_for_go
    '';
    installPhase = ''
      mkdir -p $out/bin
      cp tcdn_server_for_go $out/bin
    '';
  };

  pipe-as-file-open = pkgs.writeScriptBin "pipe-as-file-open.py" (builtins.readFile ./bin/pipe-as-file-open.py);
  tmux_capture_pane = pkgs.writeScriptBin "tmux_capture_pane" (builtins.readFile ./bin/tmux_capture_pane);
  tmux_server_for = pkgs.writeScriptBin "tmux_server_for" (builtins.readFile ./bin/tmux_server_for);

  tmux_wrapper = pkgs.writeShellScriptBin "tmux" ''
    if [[ $# -ne 0 ]]; then
        ${pkgs.tmux}/bin/tmux -u "$@";
    else
        if ! ${pkgs.tmux}/bin/tmux -u attach; then
            ${pkgs.tmux}/bin/tmux -u;
        fi;
    fi
  '';
in {
  home.packages = [tmux_wrapper pipe-as-file-open tmux_capture_pane tmux_server_for tcdn_server_for_go];

  xdg.configFile."tmux/tmux.conf".text = builtins.concatStringsSep "\n" [
    "${builtins.readFile ./config/tmux.conf}"
    "${builtins.readFile ./config/bindings.conf}"
    "${builtins.readFile ./config/theme.conf}"
  ];
}
