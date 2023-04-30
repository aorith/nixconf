{
  lib,
  pkgs,
  config,
  ...
}: {
  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };

    shellAliases = {
      ls = "ls --color=auto";
      diff = "diff --color=auto";
      grep = "grep --color=auto";
      ".." = "cd ../";
      "..." = "cd ../..";
      repos = ''cd "$(fd '\.git$' "$HOME/Syncthing/TES/gitlab" --max-depth 4 --type d --unrestricted --color never | fzf --delimiter / --with-nth -3)/.."'';
      k = "kubectl";
    };
  };

  programs = {
    dircolors.enable = true;

    fish = {
      enable = true;
      interactiveShellInit = ''
        set -g fish_greeting
      '';
    };

    bash = {
      enable = true;
      enableCompletion = true;
      historyFile = "${config.home.homeDirectory}/.local/share/.bash_history";
      # Login shell
      profileExtra = lib.concatStringsSep "\n" ([
          # Common
          ''
            export PATH="$PATH:$HOME/Syncthing/SYNC_STUFF/githome/private_dotfiles/topics/scripts-private/bin:$HOME/Syncthing/SYNC_STUFF/githome/private_dotfiles/topics/tcdn/bin"
            . "$HOME/Syncthing/SYNC_STUFF/githome/private_dotfiles/topics/tcdn/env/all/bash/04_aliases"
          ''
        ]
        ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
          # Darwin
          ''
            . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
            eval "$(/opt/homebrew/bin/brew shellenv)"
          ''
        ]);
    };

    starship = {
      enable = true;
      settings = {
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
      };
    };
  };
}
