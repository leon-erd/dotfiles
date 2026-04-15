{ self, ... }:
let
  settings = import ./_settings-base.nix;
in
{
  flake.modules.darwin.hostZollsoftMacSystemConfig =
    { ... }:
    {
      imports = with self.modules.generic; [
        configSystemOptions
        hostZollsoftMacUserConfig
      ];

      mySystemConfig.hostname = settings.hostname;
    };

  flake.modules.generic.hostZollsoftMacUserConfig =
    { ... }:
    {
      imports = with self.modules.generic; [
        configUserOptions
      ];

      myUsers = [
        {
          username = settings.username;
          name = "Leon Erd";
          email = "leon.erd@zollsoft.de";
          flakeDirectory = "/Users/${settings.username}/dotfiles";
          systemConfigurationName = settings.systemConfigurationName;
          userConfigurationName = settings.userConfigurationName;
        }
      ];
    };
}