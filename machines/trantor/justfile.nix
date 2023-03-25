{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.unstable.just
  ];

  environment.etc."justfile" = {
    mode = "0644";
    text = ''
      default:
        @just --list

      bios:
        systemctl reboot --firmware-setup

      distrobox-fbox:
        echo "Creating fbox ..."
        distrobox create --image ghcr.io/aorith/fbox:latest -n fbox -Y

      distrobox-ubuntu:
        echo "Creating ubuntu ..."
        mkdir -p "$HOME/homes"
        distrobox create --image quay.io/toolbx-images/ubuntu-toolbox:22.04 -n ubuntu -Y --home "$HOME/homes/ubuntu"

      update:
        cd "$HOME/githome/nixconf" && make switch
        flatpak update -y
        ,distrobox-update-all
    '';
  };
}
