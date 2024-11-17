{ pkgs, unstable-pkgs, ... }:
{
  config = {
    services.silverbullet = {
      enable = true;
      package = unstable-pkgs.silverbullet.overrideAttrs (oldAttrs: rec {
        version = "0.10.1";
        src = pkgs.fetchurl {
          url = "https://github.com/silverbulletmd/silverbullet/releases/download/${version}/silverbullet.js";
          hash = "sha256-4ZnA5cmLDlEUpeTBgz6Wg3XK3JJpgdt9bf9Eg7o82T8=";
        };
      });
      listenPort = 3000;
      listenAddress = "127.0.0.1";
      envFile = "/etc/silverbullet.env";
    };

    # https://github.com/NixOS/nixpkgs/pull/356163
    systemd.services.silverbullet.serviceConfig = {
      Environment = "DENO_DIR=/var/cache/silverbullet/deno";
      CacheDirectory = "silverbullet";
    };

    # For the git plugin: 
    #   Get a (beta) token scoped for this repo: https://github.com/settings/tokens
    #   Permissions: Contents -> R/W
    #   Replace origin with 'https://GITHUBTOKEN@github.com/username/repo.git'
    # envFile:
    #   GIT_COMMITTER_NAME="aorith"
    #   GIT_COMMITTER_EMAIL="git-plugin@silverbullet"
    #   GIT_AUTHOR_NAME="aorith"
    #   GIT_AUTHOR_EMAIL="git-plugin@silverbullet"
    systemd.services.silverbullet.path = with pkgs; [
      git
    ];
  };
}
