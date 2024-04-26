{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./packages
    ./programs.nix
    ./fonts
    ./zsh
  ];

  # Add different nixpkgs refs as module args
  _module.args.unstable-pkgs = import inputs.nixpkgs-unstable {
    system = "${pkgs.system}";
    config.allowUnfree = true;
  };
}
