{ ... }:

{
  flake.modules.homeManager.git =
    { config, pkgs, ... }:

    {
      home.packages = with pkgs; [
        glab
      ];

      programs.git = {
        enable = true;
        settings = {
          user = {
            name = config.myUserConfig.name;
            email = config.myUserConfig.email;
          };
          fetch.prune = true;
        };
        signing.format = "openpgp";
      };

      programs.gh.enable = true;
    };
}
