{
  networking.hostFiles = [ ./hosts ];

  security.pki.certificateFiles = [ ./tca.pem ];
}
