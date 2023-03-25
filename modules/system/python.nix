{pkgs, ...}:
#let
#  python-pkgs = p:
#    with p; [
#      requests
#      urllib3
#    ];
#in
{
  environment.systemPackages = with pkgs; [
    #(python311.withPackages python-pkgs)
    unstable.python311Packages.requests
    unstable.python311Packages.urllib3
  ];
}
