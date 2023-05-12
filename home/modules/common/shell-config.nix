{
  lib,
  pkgs,
  config,
  ...
}: {
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
      repos = ''cd "$(fd '\.git$' "$HOME/Syncthing/TES/gitlab" --max-depth 4 --type d --unrestricted --color never | fzf --delimiter / --with-nth -3,-4)/.."'';
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
      interactiveShellInit = lib.concatStringsSep "\n\n" (
        [
          # Common
          ''
            set -g fish_greeting
            fish_add_path -g --prepend $GOBIN ~/Syncthing/SYNC_STUFF/githome/private_dotfiles/topics/scripts-private/bin ~/Syncthing/SYNC_STUFF/githome/private_dotfiles/topics/tcdn/bin
            source ~/Syncthing/SYNC_STUFF/githome/private_dotfiles/topics/tcdn/env/all/bash/04_aliases

            # enable starship here manually to then enable transient prompt
            starship init fish | source
            enable_transience
          ''
        ]
        ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
          ''
            # Darwin
            fish_add_path -g ~/.docker/bin
            source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
            eval (/opt/homebrew/bin/brew shellenv)
          ''
        ]
      );
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
      profileExtra = lib.concatStringsSep "\n\n" ([
          # Common
          ''
            add_to_path() {
              # add_to_path <path> [last]
              [[ -n "$1" ]] || return 1
              case ":''${PATH}:" in
                *":''${1}:"*) ;; # already there
                *) [[ "$2" == "last" ]] && PATH="''${PATH}:''${1}" || PATH="''${1}:''${PATH}";;
              esac
              export PATH
            }

            add_to_path "$GOBIN"
            add_to_path "$HOME/Syncthing/SYNC_STUFF/githome/private_dotfiles/topics/scripts-private/bin"
            add_to_path "$HOME/Syncthing/SYNC_STUFF/githome/private_dotfiles/topics/tcdn/bin"

            export PS4='+ ''${BASH_SOURCE:-}:''${LINENO:-}: ''${FUNCNAME[0]:-}() [''${?:-}] → '

            . "$HOME/Syncthing/SYNC_STUFF/githome/private_dotfiles/topics/tcdn/env/all/bash/04_aliases"
            . "$HOME/githome/dotfiles/topics/python/env/all/bash/03_functions"
          ''
        ]
        ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
          # Darwin
          ''
            eval "$(/opt/homebrew/bin/brew shellenv)"
            . "$HOME/githome/dotfiles/topics/homebrew/env/Darwin/bash/03_functions"
            add_to_path "$HOME/.docker/bin"
          ''
        ]);
    };

    starship = {
      enable = true;
      enableFishIntegration = false; # enabled manually
      settings = {
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
          truncation_length = 4;
          truncate_to_repo = false;
        };
        cmd_duration = {
          min_time = 1000;
        };
        python = {
          detect_extensions = [];
        };
      };
    };
  };
}
