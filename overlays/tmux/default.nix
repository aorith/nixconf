final: prev: {
  tmux = prev.tmux.overrideAttrs (oldAttrs: rec {
    version = "head";
    src = prev.fetchFromGitHub {
      owner = "tmux";
      repo = "tmux";
      rev = "f372112a8df8c4fa0de6f202ea4f707e312dcc97";
      sha256 = "sha256-xL9lGjc/yN2F4faz2WW1QPoW63xXUA35T8AFczbBSWs=";
    };

    patches = null;
  });
}
