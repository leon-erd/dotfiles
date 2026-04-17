rec {
  system = "x86_64-linux"; # system arch (see hardware-configuration.nix -> nixpkgs.hostPlatform);
  hostname = "mamas-laptop";
  systemConfigurationName = hostname;

  username = "barbara";
  userConfigurationName = "${username}@${systemConfigurationName}";
}
