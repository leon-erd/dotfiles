{ self, ... }:
let
  settings = import ./_settings-base.nix;
in
{
  flake.modules.nixos.hostBarbaraLaptopSystemConfig =
    { ... }:
    {
      imports = with self.modules.generic; [
        configSystemOptions
        hostBarbaraLaptopUserConfig
      ];

      mySystemConfig = {
        hostname = settings.hostname;
        defaultLocale = "de_AT.UTF-8";
      };
    };

  flake.modules.generic.hostBarbaraLaptopUserConfig =
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
          wallpaperFolder = "/home/${settings.username}/Bilder/Wallpaper";
        }
      ];
    };
}