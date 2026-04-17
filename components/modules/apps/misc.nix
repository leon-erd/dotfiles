{ ... }:

{
  flake.modules.homeManager.appsMisc =
    { pkgs, lib, ... }:

    let
      config = {
        home.packages = with pkgs; [
          bitwarden-desktop
          meld
        ];
      };

      linuxConfig = {
        services.nextcloud-client = {
          enable = true;
          startInBackground = true;
        };
      };

    in

    lib.mkMerge [
      config
      (lib.mkIf pkgs.stdenv.isLinux linuxConfig)
    ];
}
