{
  inputs,
  pkgs,
  unstable-pkgs,
  ...
}: {
  imports = [
    # Remove on next nixos release
    "${inputs.nixpkgs-unstable}/nixos/modules/services/web-apps/silverbullet.nix"
  ];

  config = {
    services.silverbullet = {
      enable = true;
      package = unstable-pkgs.silverbullet;
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
    systemd.services.silverbullet.path = with pkgs; [git openssh];
  };
}
