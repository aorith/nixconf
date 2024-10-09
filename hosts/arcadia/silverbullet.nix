{ pkgs, unstable-pkgs, ... }:
{
  # imports = [
  #   # 24.05 is already here
  #   # "${inputs.nixpkgs-unstable}/nixos/modules/services/web-apps/silverbullet.nix"
  # ];

  config = {
    services.silverbullet = {
      enable = true;
      package = unstable-pkgs.silverbullet.overrideAttrs (oldAttrs: rec {
        version = "0.9.4";
        src = pkgs.fetchurl {
          url = "https://github.com/silverbulletmd/silverbullet/releases/download/${version}/silverbullet.js";
          hash = "sha256-J0fy1e/ObpujBNSRKA55oU30kXNfus+5P2ebggEN6Dw=";
        };
      });
      listenPort = 3000;
      listenAddress = "127.0.0.1";
      envFile = "/etc/silverbullet.env";
    };

    # For the git plugin
    # envFile:
    # GIT_SSH_COMMAND="ssh -o IdentitiesOnly=yes -i /etc/silverbullet.ssh.key -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
    # GIT_COMMITTER_NAME="aorith"
    # GIT_COMMITTER_EMAIL="git-plugin@silverbullet"
    # GIT_AUTHOR_NAME="aorith"
    # GIT_AUTHOR_EMAIL="git-plugin@silverbullet"
    systemd.services.silverbullet.path = with pkgs; [
      git
      openssh
    ];
  };
}
