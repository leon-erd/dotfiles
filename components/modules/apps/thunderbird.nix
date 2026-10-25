{ ... }:

{
  flake.modules.homeManager.thunderbird =
    { config, lib, ... }:

    {
      programs.thunderbird = {
        enable = true;
        # English is built in
        languagePacks = lib.mkDefault [ "de" ];
        # languagePacks sets RequestedLocales to its list, which would always select german.
        # Reset it so that thunderbird picks the language according to the system locale.
        policies.RequestedLocales = lib.mkIf (config.programs.thunderbird.languagePacks != [ ]) (
          lib.mkForce [ ]
        );
        profiles.${config.myUserConfig.username} = {
          isDefault = true;
          settings = {
            "extensions.activeThemeID" = "thunderbird-compact-light@mozilla.org";
          };
        };
      };
    };
}
