{ self, ... }:
let
  settings = import ./_settings-base.nix;
in
{
  flake.modules.nixos.hostChristophLaptopSystemConfig =
    { ... }:
    {
      imports = with self.modules.generic; [
        configSystemOptions
        hostChristophLaptopUserConfig
      ];

      mySystemConfig = {
        hostname = settings.hostname;
        defaultLocale = "de_DE.UTF-8";
      };
    };

  flake.modules.generic.hostChristophLaptopUserConfig =
    { ... }:
    {
      imports = with self.modules.generic; [
        configUserOptions
      ];

      myUsers = [
        {
          username = settings.username;
          name = "Christoph";
          email = "leonvincenterd@web.de";
          flakeDirectory = "/home/${settings.username}/dotfiles";
          systemConfigurationName = settings.systemConfigurationName;
          userConfigurationName = settings.userConfigurationName;
          wallpaperFolder = "/home/${settings.username}/Bilder/Wallpaper";
        }
      ];
    };
}
