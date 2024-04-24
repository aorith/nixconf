{
  programs.fzf.enable = true;
  programs.bash = {
    enable = true;
    initExtra = ''
      . ~/githome/dotfiles/topics/shell/src/bash/bashrc
    '';
  };
}
