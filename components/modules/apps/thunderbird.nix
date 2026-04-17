{ ... }:

{
  flake.modules.homeManager.thunderbird =
    { config, ... }:

    {
      programs.thunderbird = {
        enable = true;
        profiles.${config.myUserConfig.username} = {
          isDefault = true;
          settings = {
            "extensions.activeThemeID" = "thunderbird-compact-light@mozilla.org";
          };
        };
      };
    };
}
