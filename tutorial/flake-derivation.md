Just like we did without flakes, we can create a derivation using a flake:  

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
            installPhase = ''
              echo Hello World > $out
            '';
        };
      };
    };
}
```

Now, if we build the derivation from the flake:  

```bash
$ nix build .#myderiv

$ ls -l
total 8
-rw-r--r-- 1 aorith aorith 564 mar 11 13:49 flake.lock
-rw-r--r-- 1 aorith aorith 437 mar 11 14:15 flake.nix
lrwxrwxrwx 1 aorith aorith  52 mar 11 14:15 result -> /nix/store/c9ri31wz1dni6zsn6d74ngjsb5ccnwpf-my-deriv

$ cat result
Hello World
```

We can even **run** flakes directly, and not only run, but run them from a remote (git, tarball, ...):  

```nix
$ nix run github:nixos/nixpkgs/nixpkgs-unstable#cowsay -- 'Hey there'
 ___________
< Hey there >
 -----------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```
