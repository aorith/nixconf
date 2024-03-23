{pkgs, ...}: {
  programs.zsh = {
    enable = true;

    # relative to ~
    dotDir = ".config/zsh";
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    enableAutosuggestions = true;
    history.size = 10000;
    history.share = true;
    history.path = ".local/share/zsh/zsh_history";

    plugins = [
      {
        name = "zsh-powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
        file = "powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./p10k;
        file = "p10k.zsh";
      }
    ];

    envExtra = ''
      # Extended output for the time builtin.
      TIMEFMT='
       time report for `%J`
         total   %*E
         user    %U
         system  %S
         cpu     %P
         mem-avg %KKB
         mem-max %MKB
      '
    '';

    initExtraFirst = ''
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block; everything else may go below.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      emulate sh -c 'source ~/githome/dotfiles/topics/shell/etc/common/aliases.sh'
      emulate sh -c 'source ~/githome/dotfiles/topics/shell/etc/common/env.sh'
      emulate sh -c 'source ~/githome/dotfiles/topics/shell/src/bash/functions.sh'
    '';

    initExtra = ''
      unsetopt correct # autocorrect commands

      setopt hist_ignore_all_dups # remove older duplicate entries from history
      setopt hist_reduce_blanks # remove superfluous blanks from history items
      setopt inc_append_history # save history entries as soon as they are entered
      setopt rm_star_wait # wait for 10 seconds confirmation when running rm with *
      setopt auto_param_slash # complete folders with / at end

      # auto complete options
      setopt auto_list # automatically list choices on ambiguous completion
      setopt auto_menu # automatically use menu completion
      zstyle ':completion:*' menu select # select completions with arrow keys
      zstyle ':completion:*' group-name "" # group results by category
    '';

    shellAliases = {
      # Overrides those provided by OMZ libs, plugins, and themes.
      # For a full list of active aliases, run `alias`.

      #------------Navigation------------
      l = "${pkgs.eza}/bin/eza -lah --git --git-repos --icons=auto";
      la = "${pkgs.eza}/bin/eza -lah --git --git-repos --icons=auto";
      ll = "${pkgs.eza}/bin/eza -lh --git --git-repos --icons=auto";
      #ls = "${pkgs.eza}/bin/eza"; # some flags like '-t' do not behave like ls
    };
  };
}
