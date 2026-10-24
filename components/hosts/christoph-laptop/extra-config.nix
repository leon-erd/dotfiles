{ ... }:
{
  flake.modules.nixos.hostChristophLaptopSystemExtra =
    { pkgs, ... }:
    {
      system.stateVersion = "23.11"; # Do not modify
    };

  flake.modules.homeManager.hostChristophLaptopHmExtra =
    { lib, config, ... }:
    {
      programs.firefox.profiles.${config.myUserConfig.username} = {
        bookmarks = lib.mkForce { };
        search = lib.mkForce {
          default = "ecosia";
          force = true;
        };
      };

      home.stateVersion = "23.11"; # Do not modify
    };
}
