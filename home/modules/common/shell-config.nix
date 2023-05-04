{
  lib,
  pkgs,
  config,
  ...
}: let
  # starship preset bracketed-segments -o ./bracketed-segments.toml
  starship-bracketed-segments = builtins.fromTOML (builtins.readFile ./starship/bracketed-segments.toml);
in {
  home = {
    sessionVariables =
      {
        # Common
        EDITOR = "nvim";
        GOPATH = "$HOME/.local/go";
        GOBIN = "$HOME/.local/go/bin";
        _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
      }
      // pkgs.lib.attrsets.optionalAttrs pkgs.stdenv.isDarwin {
        # Darwin only
        LANG = "en_US.UTF-8";
        LANGUAGE = "en_US.UTF-8";
        LC_COLLATE = "C";
        LC_CTYPE = "UTF-8";
      };

    shellAliases = {
      ls = "ls --color=auto";
      diff = "diff --color=auto";
      grep = "grep --color=auto";
      ".." = "cd ../";
      "..." = "cd ../..";
      repos = ''cd "$(fd '\.git$' "$HOME/Syncthing/TES/gitlab" --max-depth 4 --type d --unrestricted --color never | fzf --delimiter / --with-nth -3)/.."'';
      k = "kubectl";
      nixconf = "cd ${config.home.homeDirectory}/githome/nixconf";
      dotfiles = "cd ${config.home.homeDirectory}/githome/dotfiles";
    };
  };

  programs = {
    dircolors.enable = true;
    readline = {
      enable = true;
      extraConfig = ''
        set bell-style none
        set colored-stats On
        set colored-completion-prefix On
        set visible-stats On
        set mark-symlinked-directories On
        set menu-complete-display-prefix On
        set enable-bracketed-paste On
        set show-all-if-ambiguous On
        set show-all-if-unmodified On
      '';
    };

    fish = {
      enable = true;
      interactiveShellInit = lib.concatStringsSep "\n" ([
          # Common
          ''
            set -g fish_greeting

            fish_add_path -g --prepend $GOBIN ~/Syncthing/SYNC_STUFF/githome/private_dotfiles/topics/scripts-private/bin ~/Syncthing/SYNC_STUFF/githome/private_dotfiles/topics/tcdn/bin

            source ~/Syncthing/SYNC_STUFF/githome/private_dotfiles/topics/tcdn/env/all/bash/04_aliases
          ''
        ]
        ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
          ''
            # Darwin
            fish_add_path -g ~/.docker/bin
            source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
            eval (/opt/homebrew/bin/brew shellenv)
          ''
        ]);
    };

    bash = {
      enable = true;
      enableCompletion = true;

      historyFile = "${config.home.homeDirectory}/.local/share/.bash_history";
      historyControl = ["erasedups" "ignoredups" "ignorespace"];
      shellOptions = [
        "autocd"
        "checkjobs"
        "checkwinsize"
        "cmdhist"
        "extglob"
        "globstar"
        "histappend"
      ];

      # Login shell
      profileExtra = lib.concatStringsSep "\n" ([
          # Common
          ''
            export PS4='+ ''${BASH_SOURCE:-}:''${LINENO:-}: ''${FUNCNAME[0]:-}() [''${?:-}] → '

            export PATH="$PATH:$GOBIN:$HOME/Syncthing/SYNC_STUFF/githome/private_dotfiles/topics/scripts-private/bin:$HOME/Syncthing/SYNC_STUFF/githome/private_dotfiles/topics/tcdn/bin"
            . "$HOME/Syncthing/SYNC_STUFF/githome/private_dotfiles/topics/tcdn/env/all/bash/04_aliases"

            . "$HOME/githome/dotfiles/topics/python/env/all/bash/03_functions"
          ''
        ]
        ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
          # Darwin
          ''
            eval "$(/opt/homebrew/bin/brew shellenv)"
            . "$HOME/githome/dotfiles/topics/homebrew/env/Darwin/bash/03_functions"
            export PATH="$HOME/.docker/bin:$PATH"
          ''
        ]);
    };

    starship = {
      enable = true;
      settings =
        lib.recursiveUpdate starship-bracketed-segments
        {
          add_newline = false;
          format = lib.concatStrings [
            "$time"
            "$username"
            "$hostname"
            "$directory"
            "$git_branch"
            "$git_commit"
            "$git_state"
            "$git_status"
            "$nix_shell"
            "$python"
            "$kubernetes"
            "$container"
            "$package" # curr dir is a repo for a package (cargo, python, helm, ...)
            "$jobs"
            "$cmd_duration"
            "$status"
            "$line_break"
            "$character"
          ];
          command_timeout = 500; # 500 = default
          time = {
            disabled = false;
            time_format = "%H:%M";
            format = "[$time]($style) ";
            style = "white dimmed";
          };
          jobs = {
            format = "[$number]($style) ";
            number_threshold = 1;
          };
          status = {
            disabled = false;
            format = "[$status]($style) ";
          };
          directory = {
            truncation_symbol = "…/";
            truncate_to_repo = false;
            truncation_length = 4;
          };
          cmd_duration = {
            min_time = 1000;
          };
          python = {
            detect_extensions = [];
          };
          kubernetes = {
            disabled = false;
            detect_extensions = ["yaml"];
          };
        };
    };
  };
}
