{ ... }:
{
  flake.modules.nixos.hostBarbaraLaptopSystemExtra =
    { pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages_latest;
      system.stateVersion = "23.11"; # Do not modify
    };

  flake.modules.homeManager.hostBarbaraLaptopHmExtra =
    { lib, config, ... }:
    {
      programs.firefox.profiles.${config.myUserConfig.username} = {
        bookmarks = lib.mkForce { };
        search = lib.mkForce {
          default = "ecosia";
          force = true;
        };
      };

      wayland.windowManager.hyprland.settings = {
        monitor = lib.mkForce ", preferred, auto, 1.25";
      };

      services.network-manager-applet.enable = true;
      services.blueman-applet.enable = true;

      home.activation = {
        myScripts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          run ln -Tsf ${config.myUserConfig.flakeDirectory}/components/scripts ~/scripts
        '';
      };

      home.stateVersion = "23.11"; # Do not modify
    };
}
