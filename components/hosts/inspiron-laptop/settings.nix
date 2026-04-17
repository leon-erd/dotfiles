{ self, ... }:
let
  settings = import ./_settings-base.nix;
in
{
  flake.modules.nixos.hostInspironLaptopSystemConfig =
    { ... }:
    {
      imports = with self.modules.generic; [
        configSystemOptions
        hostInspironLaptopUserConfig
      ];

      mySystemConfig.hostname = settings.hostname;
    };

  flake.modules.generic.hostInspironLaptopUserConfig =
    { ... }:
    {
      imports = with self.modules.generic; [
        configUserOptions
      ];

      myUsers = [
        {
          username = settings.username;
          name = "Leon";
          email = "leonvincenterd@web.de";
          flakeDirectory = "/home/${settings.username}/dotfiles";
          systemConfigurationName = settings.systemConfigurationName;
          userConfigurationName = settings.userConfigurationName;
          wallpaperFolder = "/home/${settings.username}/Nextcloud/Pictures/Geordnet";
          wireguardConfig = ../../secrets/files/wireguard_clients/inspiron-laptop.conf;
        }
      ];
    };
}
