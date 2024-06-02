{ pkgs, ... }:
{
  programs.fzf.enable = true;
  programs.bash = {
    enable = true;
    initExtra = ''
      . ~/githome/dotfiles/topics/shell/src/bash/bashrc
    '';

    shellAliases = {
      l = "${pkgs.eza}/bin/eza -lah --git --git-repos --icons=auto";
      la = "${pkgs.eza}/bin/eza -lah --git --git-repos --icons=auto";
      ll = "${pkgs.eza}/bin/eza -lh --git --git-repos --icons=auto";
      #ls = "${pkgs.eza}/bin/eza"; # some flags like '-t' do not behave like ls

      cat = "${pkgs.bat}/bin/bat --plain --theme='Monokai Extended'";
    };
  };
}
