{ userSettings, ... }:

{
  programs.thunderbird = {
    enable = true;
    profiles.${userSettings.username} = {
      isDefault = true;
      settings = {
        "extensions.activeThemeID" = "thunderbird-compact-light@mozilla.org";
      };
    };
  };
}
