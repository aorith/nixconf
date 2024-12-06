{ pkgs, unstable-pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    unstable-pkgs.alacritty
    unstable-pkgs.flameshot
    #unstable-pkgs.wezterm

    calibre
    chromium
    evince
    gimp-with-plugins
    google-chrome
    keepassxc
    libnotify
    mpv
    pamixer
    pavucontrol
    pulseaudioFull
    wl-clipboard
    xclip
    xorg.xev
    xorg.xprop
    xsel

    solaar
    logitech-udev-rules
  ];

  hardware.steam-hardware.enable = true;
  services.flatpak.enable = true;
  programs = {
    firefox = {
      enable = true;
      languagePacks = [
        "en-US"
        "es-ES"
      ];

      # ---- POLICIES ----
      # Check about:policies#documentation for options.
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        OverrideFirstRunPage = "tabliss";
        OverridePostUpdatePage = "tabliss";
        DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
        DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
        SearchBar = "unified"; # alternative: "separate"

        # ---- EXTENSIONS ----
        # Valid strings for installation_mode are "allowed", "blocked",
        # "force_installed" and "normal_installed".
        ExtensionSettings =
          with builtins;
          let
            extension = shortId: uuid: {
              name = uuid;
              value = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/${shortId}/latest.xpi";
                installation_mode = "normal_installed";
              };
            };
          in
          # To add additional extensions, find it on addons.mozilla.org, find
          # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
          # Then, download the XPI by filling it in to the install_url template, unzip it,
          # run `jq .browser_specific_settings.gecko.id manifest.json` or
          # `jq .applications.gecko.id manifest.json` to get the UUID
          listToAttrs [
            (extension "sidebery" "{3c078156-979c-498b-8990-85f7987dd929}")
            (extension "tabliss" "extension@tabliss.io")
          ];

        # ---- PREFERENCES ----
        # Check about:config for options.
        Preferences = {
          "extensions.pocket.enabled" = {
            # Extension similar to bookmarks to save content to view it later
            Value = false;
            Status = "locked";
          };
          "browser.topsites.contile.enabled" = {
            # Tiles with "top-sites" like Ama**on
            Value = false;
            Status = "locked";
          };
          "browser.formfill.enable" = {
            # Remember form information
            Value = false;
            Status = "locked";
          };
          "browser.newtabpage.enabled" = {
            Value = false;
            Status = "locked";
          };
        };
      };
    };
  };
}
