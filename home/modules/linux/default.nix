{pkgs, ...}: {
  home = {
    file.".local/share/flatpak/overrides/global".text = ''
      [Context]
      filesystems=~/.local/share/icons:ro;~/.local/share/fonts:ro;~/.local/share/sounds:ro
    '';

    file.".justfile".text = builtins.readFile ./justfile;
  };

  home.packages = [
    pkgs.pgadmin4-desktopmode # pgadmin web app
  ];

  #services.clipmenu.enable = true;
}
