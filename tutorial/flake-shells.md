Another output attribute of flakes are `devShells`.  
This allows us to create on-demand shells with the tools that we need.  

```nix
{
  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11"; };

  outputs = inputs:
    let
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system} = {
        myshell = pkgs.mkShell {
          buildInputs = [ pkgs.hello ];
        };
      };
    };
}
```

The above example allows us to create a shell environment where the package `hello` is available.
To active the shell we use the command `nix develop .#<name>`:  

```bash
$ hello
The program 'hello' is not in your PATH. It is provided by several packages.
You can make it available in an ephemeral shell by typing one of the following:
  nix-shell -p fltk
  nix-shell -p fltk14
  nix-shell -p haskellPackages.hello
  nix-shell -p hello
  nix-shell -p mbedtls

$ nix develop .#myshell
$ hello
Hello, world!
```

If we name our shell `default`:  

```nix
      devShells.${system} = {
        default = pkgs.mkShell {
```

We can just execute `nix develop` to active it.  
