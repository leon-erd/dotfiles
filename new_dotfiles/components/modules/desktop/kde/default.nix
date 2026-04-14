{ self, ... }:

{
  flake.modules.nixos.kde =
    { ... }:

    {
      imports = [
        self.modules.nixos.xserver
      ];

      services.desktopManager.plasma6.enable = true;
      # the plasma6 module sets itself as the default session which I don't want
      services.displayManager.defaultSession = null;
    };

  flake.modules.homeManager.kde =
    { inputs, ... }:

    {
      imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

      # https://github.com/nix-community/stylix/issues/267#issuecomment-2314636091
      programs.plasma = {
        enable = true;
        configFile.kded5rc = {
          "Module-gtkconfig"."autoload" = false;
        };
      };
    };
}
