# Pin tmux version, 3.4 search is broken atm
final: prev: {
  tmux = prev.tmux.overrideAttrs (oldAttrs: rec {
    version = "3.3a";
    src = prev.fetchFromGitHub {
      owner = "tmux";
      repo = "tmux";
      rev = version;
      sha256 = "sha256-SygHxTe7N4y7SdzKixPFQvqRRL57Fm8zWYHfTpW+yVY=";
    };
  });
}
