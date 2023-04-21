{
  config,
  pkgs,
  ...
}: {
  age.secrets.hosts.file = ../../../secrets/hosts.age;

  # this doesn't need to be a secret, it's just an example to show
  # that secrets are available after activation, not on 'build'
  #
  # this doesn't work:
  # networking.hostFiles = [config.age.secrets.hosts.path];
  #
  # this works
  systemd.services.update-hosts = {
    description = "Update Hosts file";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/cat ${config.age.secrets.hosts.path} >> /etc/hosts'
      '';
    };
  };

  security.pki.certificateFiles = [
    ./tca.pem
  ];
}
