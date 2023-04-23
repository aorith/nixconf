{lib, ...}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = false;
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
      };
      cmd_duration = {
        min_time = 1000;
      };
    };
  };
}
