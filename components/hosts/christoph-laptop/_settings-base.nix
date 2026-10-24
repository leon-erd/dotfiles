rec {
  system = "x86_64-linux"; # system arch (see hardware-configuration.nix -> nixpkgs.hostPlatform);
  hostname = "papas-laptop";
  systemConfigurationName = hostname;

  username = "christoph";
  userConfigurationName = "${username}@${systemConfigurationName}";
}
