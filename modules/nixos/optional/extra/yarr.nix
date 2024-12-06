{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.yarr;
  defaultUser = "yarr";
  defaultGroup = defaultUser;
in
{
  options = {
    services.yarr = {
      enable = lib.mkEnableOption (
        lib.mdDoc "yarr (yet another rss reader) is a web-based feed aggregator which can be used both as a desktop application and a personal self-hosted server."
      );

      package = lib.mkPackageOption pkgs "yarr" { };

      envFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/etc/yarr.env";
        description = lib.mdDoc ''
          File containing config environment variables. For example:

          ```
          YARR_ADDR=127.0.0.1:7070
          YARR_AUTHFILE=/etc/yarr.auth
          ```
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    users.users.${defaultUser} = {
      description = "Yarr user";
      group = defaultGroup;
      isSystemUser = true;
    };
    users.groups.${defaultGroup} = { };

    systemd.services.yarr = {
      description = "Yarr Feed Reader service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/yarr";
        User = defaultUser;
        DynamicUser = true;
        StateDirectory = "yarr";
        StateDirectoryMode = "0700";
        Environment = [ "XDG_CONFIG_HOME=%S" ];
        EnvironmentFile = lib.mkIf (cfg.envFile != null) "${cfg.envFile}";
        # Hardening
        CapabilityBoundingSet = [ "" ];
        DeviceAllow = [ "" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        UMask = "0077";
      };
    };
  };
}
