rec {
  system = "x86_64-linux"; # system arch (see hardware-configuration.nix -> nixpkgs.hostPlatform);
  hostname = "inspiron-laptop";
  systemConfigurationName = hostname;

  username = "leon";
  userConfigurationName = "${username}@${systemConfigurationName}";
}
