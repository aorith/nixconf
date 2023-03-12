Flake outputs have a schema, we've already seen `packages` and `devShells` but there are more:

```nix
{
  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11"; };

  outputs = inputs:
    let
      system = "x86_64-linux";
    in
    {
      packages.${system} = {};
      apps.${system} = {};
      devShells.${system} = {};
      checks.${system} = {};
      formatter = {};
      overlays = {};
      nixosConfigurations = {};
      nixosModules = {};
      templates = {};
      hydraJobs = {};
    };
}
```

We can check them with the show command:  

```bash
$ nix flake show
path:/home/aorith/githome/nixconf/tutorial/test?lastModified=1678544717&narHash=sha256-0m69DdGBip67aakwXSIB5AKVths8WskFLkY7TjLfmnA=
├───apps
│   └───x86_64-linux
├───checks
│   └───x86_64-linux
├───devShells
│   └───x86_64-linux
├───formatter
├───hydraJobs
├───nixosConfigurations
├───nixosModules
├───overlays
├───packages
│   └───x86_64-linux
└───templates
```

If we specify something that isn't in the schema it appears as *unknown*:  

```nix
$ nix flake show
path:/home/aorith/githome/nixconf/tutorial/test?lastModified=1678544845&narHash=sha256-QatWCXybLPXlwY9viQqKJ7xdBwf%2fgNp7JRje6yqEK7M=
├───packages
│   └───x86_64-linux
└───what: unknown
```
