{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  # By default, Home Manager uses a private pkgs instance that is configured via the home-manager.users.<name>.nixpkgs options.
  # This saves an extra Nixpkgs evaluation, adds consistency, and removes the dependency on NIX_PATH, which is otherwise used for importing Nixpkgs.
  home-manager.useGlobalPkgs = true;

  # Install packages to /etc/profiles instead of $HOME/.nix-profile, this will become the default.
  home-manager.useUserPackages = true;

  home-manager.users.aorith = import ./home-linux.nix;
  home-manager.extraSpecialArgs = {inherit inputs;};
}
