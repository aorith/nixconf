{pkgs, ...}: let
  python-pkgs = p:
    with p; [
      requests
      urllib3
    ];
in {
  environment.systemPackages = with pkgs; [
    (python3.withPackages python-pkgs)
  ];
}
