Nix has other tooling to make this easier but the basics are as follows.  

```nix
# mydev.nix
let
  pkgs = import <nixpkgs> { };
in pkgs.stdenv.mkDerivation {
  name = "example-derivation";

  src = ./.; # imports all the files from the cwd

  installPhase = ''
    cat script.sh > $out
  '';
}
```

And the `script.sh` file:  

```bash
#!/usr/bin/env bash
echo "Hello world"
```

Now build it and check the result:  

```bash
$ nix build --file ./mydev.nix

$ ls -l
-rw-r--r-- 1 aorith aorith 199 mar 11 13:22 mydev.nix
-rw-r--r-- 1 aorith aorith  39 mar 11 13:22 script.sh
lrwxrwxrwx 1 aorith aorith  62 mar 11 13:23 result -> /nix/store/7ajwkjp6m3mh7q0ix9fp16lhha5z4jih-example-derivation

$ cat result
#!/usr/bin/env bash
echo "Hello world"
```

