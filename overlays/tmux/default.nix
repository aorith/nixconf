# Pin tmux version, 3.4 search is broken atm
final: prev: {
  tmux = prev.tmux.overrideAttrs (oldAttrs: rec {
    # version = "3.3a";
    version = "3.4";
    src = prev.fetchFromGitHub {
      owner = "tmux";
      repo = "tmux";
      # rev = version;
      rev = "c07e856d244d07ab2b65e72328fb9fe20747794b";
      sha256 = "sha256-99hdAskEByqD4fjl2wrth9QfSkPXkN7o2A9e+BOH6ug=";
    };

    patches = null;
  });
}
