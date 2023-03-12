Derivations make special treatment in the build phase.  
Let's see it in an example:  

Create a file named `script.sh` and give it execution permissions:  

```bash
#!/usr/bin/env bash
cd "$(dirname -- "$0")" || exit 1
```

And a `flake.nix` file:  

```nix
{
  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11"; };

  outputs = inputs:
    let
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system} = {
        myderiv = pkgs.stdenv.mkDerivation {
            name = "my-deriv";
            src = ./.;
            buildInputs = [
              pkgs.hello
            ];
            dontFixup = false;
            installPhase = ''
              cp script.sh $out
              echo -e '\n${pkgs.hello}/bin/hello\n' >> $out
            '';
        };
      };
    };
}
```

Notice the `dontFixup` attribute set to `false`, when we build the flake and inspect it:  

```bash
$ nix build .#myderiv

$ cat result
#!/nix/store/96ky1zdkpq871h2dlk198fz0zvklr1dr-bash-5.1-p16/bin/bash
cd "$(dirname -- "$0")" || exit 1

/nix/store/hrqijlzk6b56ij6g86vdh2b8mkv1i469-hello-2.12.1/bin/hello

$ ./result
Hello, world!
```

We can see how the `#!/usr/bin/env bash` was replaced by the direct reference to bash in the nix store.  
If we set `dontFixup` to `true`, that is not the case:  

```nix
$ nix build .#myderiv

$ cat result
#!/usr/bin/env bash
cd "$(dirname -- "$0")" || exit 1

/nix/store/hrqijlzk6b56ij6g86vdh2b8mkv1i469-hello-2.12.1/bin/hello
```
