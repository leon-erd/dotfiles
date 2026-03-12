{ userSettings, pkgs, ... }:

{
  home.packages = with pkgs; [
    glab
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = userSettings.name;
        email = userSettings.email;
      };
      fetch.prune = true;
    };
  };

  programs.gh.enable = true;
}
