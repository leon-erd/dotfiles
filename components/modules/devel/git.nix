{ ... }:

{
  flake.modules.homeManager.git =
    {
      config,
      lib,
      pkgs,
      ...
    }:

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
          core.editor = lib.getExe pkgs.nano;
          fetch.prune = true;
        };
        signing.format = "openpgp";
      };

      programs.gh.enable = true;
    };
}
