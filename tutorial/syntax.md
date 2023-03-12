A nix file, can be a single expression, like a number or a string:  

```nix
"a string"
```

Or we can use `let ... in` to create variable bindings:  

```nix
# test.nix
let
  x = 5;
in
  x
```

We can evaluate a file with `nix eval`:  

```bash
$ nix eval --file ./test.nix
5
```

Nix also has attribute sets:  

```nix
let
  x = {
    # name is a property
    name = "Manuel";
  };
in
  # We can do some string concatenation
  "Hello " + x.name
```

And lists:  

```nix
let
  # Separated by spaces
  x = [ 1 2 3 ];
in
  x
```

And functions, functions in nix take one argument:  

```nix
let
  greet = name: "Hello ${name}";
in
  greet "Manuel"

# output:
"Hello Manuel"
```

We can use it in another attribute set:  

```nix
let greet = name: "Hello ${name}";
in {
  x = greet "Manuel";
  y = greet "María";
}

# output:
{ x = "Hello Manuel"; y = "Hello María"; }
```

Functions take one argument, but that argument can be an attribute set:  

```nix
let
  mult = { x, y }: { val = x*y; };
in
  mult { x=2; y=3; }

# output:
{ val = 6; }
```
