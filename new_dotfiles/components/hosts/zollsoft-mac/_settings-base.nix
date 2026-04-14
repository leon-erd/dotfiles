rec {
  system = "aarch64-darwin"; # system arch
  hostname = "zollsoft-mac";
  systemConfigurationName = hostname;

  username = "leon.erd";
  userConfigurationName = "${username}@${systemConfigurationName}";
}