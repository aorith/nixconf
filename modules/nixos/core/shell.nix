{ pkgs, ... }:
{
  programs = {
    bash = {
      enableLsColors = true;
      completion.enable = true;

      shellAliases = {
        l = "${pkgs.eza}/bin/eza -lah --git --git-repos --icons=auto";
        la = "${pkgs.eza}/bin/eza -lah --git --git-repos --icons=auto";
        ll = "${pkgs.eza}/bin/eza -lh --git --git-repos --icons=auto";
        #ls = "${pkgs.eza}/bin/eza"; # some flags like '-t' do not behave like ls

        cat = "${pkgs.bat}/bin/bat -P --plain --theme='ansi'";
      };
    };
    # zsh = {
    #   enable = true;
    #   enableCompletion = true;
    #   enableBashCompletion = true;
    # };
  };

  # Completion for system packages
  # environment.pathsToLink = [ "/share/zsh" ];
}
