# Pin tmux version, 3.4 search is broken atm
final: prev: {
  tmux = prev.tmux.overrideAttrs (oldAttrs: rec {
    # version = "3.3a";
    version = "3.4";
    src = prev.fetchFromGitHub {
      owner = "tmux";
      repo = "tmux";
      # rev = version;
      rev = "c773fe89e7ac75fbf86bfce30d86ebf44e5c20e2";
      sha256 = "sha256-yhPhJ6Z4OojaNj/LElCCwOMGVRc0YnveQ1ScRNLrbP0=";
    };

    patches = null;
  });
}
