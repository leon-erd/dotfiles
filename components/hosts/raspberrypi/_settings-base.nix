rec {
  system = "aarch64-linux"; # system arch (see hardware-configuration.nix -> nixpkgs.hostPlatform);
  hostname = "raspberrypi";
  systemConfigurationName = hostname;

  username = "leon";
  userConfigurationName = "${username}@${systemConfigurationName}";
}
