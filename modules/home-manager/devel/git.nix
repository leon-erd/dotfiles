{ userSettings, ... }:

{
  programs.git = {
    enable = true;
    settings.user = {
      name = userSettings.name;
      email = userSettings.email;
    };
  };
}
