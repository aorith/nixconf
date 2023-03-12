A basic flake has `inputs` and `outputs`:  

```nix
{
  inputs = {};
  outputs = {};
}
```

`inputs` are the _things_ you need in order to construct your `outputs`.  

For example, if you need packages you need to specify them:  

```nix
{
  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11"; };

  # "inputs" here is an argument to the function outputs, it can be named
  # differently and it wouldn't matter
  outputs = inputs: {
    # outputs has a schema that nix knows about, for example "packages"
    packages = {
      x86_64-linux = {
        myhello = inputs.nixpkgs.legacyPackages.x86_64-linux.hello;
      };
    };
  };
}
```

Where does `x86_64-linux` come from?  
That's a supported platform in the nixpkgs repository, if you want to query the platforms you can use `nix repl`:  

```bash
# :l  --> "Load"
$ nix repl
nix-repl> :l <nixpkgs>
Added 17749 variables.

nix-repl> lib.platforms.all
[ "i686-cygwin" "x86_64-cygwin" "x86_64-darwin" "i686-darwin" "aarch64-darwin" "armv7a-darwin" "i686-freebsd13" "x86_64-freebsd13" "aarch64-genode" "i686-genode" "x86_64-genode" "x86_64-solaris" "js-ghcjs" "aarch64-linux" "armv5tel-linux" "armv6l-linux" "armv7a-linux" "armv7l-linux" "i686-linux" "m68k-linux" "microblaze-linux" "microblazeel-linux" "mipsel-linux" "mips64el-linux" "powerpc64-linux" "powerpc64le-linux" "riscv32-linux" "riscv64-linux" "s390-linux" "s390x-linux" "x86_64-linux" "mmix-mmixware" "aarch64-netbsd" "armv6l-netbsd" "armv7a-netbsd" "armv7l-netbsd" "i686-netbsd" "m68k-netbsd" "mipsel-netbsd" "powerpc-netbsd" "riscv32-netbsd" "riscv64-netbsd" "x86_64-netbsd" "aarch64_be-none" "aarch64-none" "arm-none" "armv6l-none" "avr-none" "i686-none" "microblaze-none" "microblazeel-none" "msp430-none" "or1k-none" "m68k-none" "powerpc-none" "powerpcle-none" "riscv32-none" "riscv64-none" "rx-none" "s390-none" "s390x-none" "vc4-none" "x86_64-none" "i686-openbsd" "x86_64-openbsd" "x86_64-redox" "wasm64-wasi" "wasm32-wasi" "x86_64-windows" "i686-windows" ]
```

Where does the `myhello` package come from?  
Save the above file as `flake.nix`, run `nix flake update` and then enter the repl with `nix repl`:  

```nix
# :lf .  -> Load Flake
$ nix repl

nix-repl> :lf .
Added 8 variables.

nix-repl> inputs.nixpkgs. # Press <TAB> here
inputs.nixpkgs.checks            inputs.nixpkgs.nixosModules
inputs.nixpkgs.htmlDocs          inputs.nixpkgs.outPath
inputs.nixpkgs.inputs            inputs.nixpkgs.outputs
inputs.nixpkgs.lastModified      inputs.nixpkgs.rev
inputs.nixpkgs.lastModifiedDate  inputs.nixpkgs.shortRev
inputs.nixpkgs.legacyPackages    inputs.nixpkgs.sourceInfo
inputs.nixpkgs.lib
inputs.nixpkgs.narHash

nix-repl> inputs.nixpkgs.legacyPackages. # press <TAB> here
inputs.nixpkgs.legacyPackages.aarch64-darwin
inputs.nixpkgs.legacyPackages.aarch64-linux
inputs.nixpkgs.legacyPackages.armv5tel-linux
inputs.nixpkgs.legacyPackages.armv6l-linux
inputs.nixpkgs.legacyPackages.armv7l-linux
inputs.nixpkgs.legacyPackages.i686-linux
inputs.nixpkgs.legacyPackages.mipsel-linux
inputs.nixpkgs.legacyPackages.powerpc64le-linux
inputs.nixpkgs.legacyPackages.riscv64-linux
inputs.nixpkgs.legacyPackages.x86_64-darwin
inputs.nixpkgs.legacyPackages.x86_64-linux

nix-repl> inputs.nixpkgs.legacyPackages.x86_64-linux.hello
«derivation /nix/store/m7clchh41sryqpiz6x4mbrwhv4n08k3g-hello-2.12.1.drv»
```

Now let's try to build the flake.
The syntax to build a flake is:  

```bash
$ nix build .#<name>
```

Where `<name>` is the specific attribute name that we want to use, in this case:  

```bash
$ nix build .#myhello

$ ls -l
total 8
-rw-r--r-- 1 aorith aorith 564 mar 11 13:49 flake.lock
-rw-r--r-- 1 aorith aorith 407 mar 11 13:54 flake.nix
lrwxrwxrwx 1 aorith aorith  56 mar 11 13:57 result -> /nix/store/hrqijlzk6b56ij6g86vdh2b8mkv1i469-hello-2.12.1

$ ./result/bin/hello
Hello, world!
```

Magic!  

This has created a reproducible build of the package hello world, if you peek into the `flake.lock` file  
you can see the locked version of the input that was used:  

```json
{
  "nodes": {
    "nixpkgs": {
      "locked": {
        "lastModified": 1678426640,
        "narHash": "sha256-3Q4KN0XAXQT7YE3A8n3LzLtRNUCo0U++W3gl+5NhKHs=",
        "owner": "nixos",
        "repo": "nixpkgs",
        "rev": "824f886682fc893e6dbf27114e5001ebf2770ea1",
        "type": "github"
      },
      "original": {
        "owner": "nixos",
        "ref": "nixos-22.11",
        "repo": "nixpkgs",
        "type": "github"
      }
    },
    "root": {
      "inputs": {
        "nixpkgs": "nixpkgs"
      }
    }
  },
  "root": "root",
  "version": 7
}
```

A useful command to "debug" flakes is `nix flake show`:  

```bash
$ nix flake show
path:/home/aorith/githome/nixconf/tutorial/test?lastModified=1678539437&narHash=sha256-+CQqfTmhM1nbTkH0n18oC49Wwu0IDZxMif6nB4LcIx8=
└───packages
    └───x86_64-linux
        └───myhello: package 'hello-2.12.1'
```

We can leverage `let in` to simplify the flake:  

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
        myhello = pkgs.hello;
      };
    };
}
```
