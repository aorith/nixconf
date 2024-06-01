{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh"; # relative to ~
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    defaultKeymap = "emacs";
    history.size = 10000;
    history.share = true;
    history.path = "$HOME/.config/zsh/.zsh_history";

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

      # Titles
      __title_precmd () { print -Pn -- "\e]0;zsh [%~]\a" }
      __title_preexec () { print -n -- "\e]0;$1 " && print -Pn -- "[%~]\a" }
      precmd_functions+=(__title_precmd)
      preexec_functions+=(__title_preexec)

      unsetopt correct # autocorrect commands
      unsetopt inc_append_history # save history entries as soon as they are entered

      setopt hist_ignore_all_dups # remove older duplicate entries from history
      setopt hist_reduce_blanks # remove superfluous blanks from history items
      setopt rm_star_wait # wait for 10 seconds confirmation when running rm with *
      setopt auto_param_slash # complete folders with / at end

      # auto complete options
      setopt auto_list # automatically list choices on ambiguous completion
      setopt auto_menu # automatically use menu completion
      zstyle ':completion:*' menu select # select completions with arrow keys
      zstyle ':completion:*' group-name "" # group results by category
      zstyle ':completion:*' special-dirs true # need this for ..<TAB>, so it adds the '/'

      typeset -U PATH
    '';

    initExtra = ''
      emulate sh -c 'source ~/githome/dotfiles/topics/shell/etc/common/aliases.sh'
      emulate sh -c 'source ~/githome/dotfiles/topics/shell/etc/common/env.sh'
      emulate sh -c 'source ~/githome/dotfiles/topics/shell/src/bash/functions.sh'

      # Fix home, delete, ... keys
      bindkey "^[[3~" delete-char
      case $TERM_PROGRAM in
      tmux)
          bindkey "^[[1~" beginning-of-line
          bindkey "^[[4~" end-of-line
          ;;
      WezTerm)
          # Ctrl-V + <key>
          bindkey "^[OH" beginning-of-line
          bindkey "^[OF" end-of-line
          ;;
      esac
    '';

    shellAliases = {
      # Overrides those provided by OMZ libs, plugins, and themes.
      # For a full list of active aliases, run `alias`.

      #------------Navigation------------
      l = "${pkgs.eza}/bin/eza -lah --git --git-repos --icons=auto";
      la = "${pkgs.eza}/bin/eza -lah --git --git-repos --icons=auto";
      ll = "${pkgs.eza}/bin/eza -lh --git --git-repos --icons=auto";
      #ls = "${pkgs.eza}/bin/eza"; # some flags like '-t' do not behave like ls

      cat = "${pkgs.bat}/bin/bat --plain --theme='Monokai Extended'";
    };
  };
}
