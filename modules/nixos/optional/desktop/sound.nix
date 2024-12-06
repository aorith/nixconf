{ lib, pkgs, ... }:
{
  # Enable sound.
  hardware.pulseaudio.enable = lib.mkForce false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # wireplumber.configPackages = [
    #   (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/alsa.conf" ''
    #     monitor.alsa.rules = [
    #       {
    #         matches = [
    #           {
    #             device.name = "~alsa_card.*"
    #           }
    #         ]
    #         actions = {
    #           update-props = {
    #             # Device settings
    #             api.alsa.use-acp = true
    #           }
    #         }
    #       }
    #       {
    #         matches = [
    #           {
    #             node.name = "~alsa_input.pci.*"
    #           }
    #           {
    #             node.name = "~alsa_output.pci.*"
    #           }
    #         ]
    #         actions = {
    #         # Node settings
    #           update-props = {
    #             session.suspend-timeout-seconds = 0
    #           }
    #         }
    #       }
    #     ]
    #   '')
    # ];
  };

  security.rtkit.enable = true;
}
