{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        remoteDeploymentSystem = pkgs.writeShellApplication {
          name = "remote-deployment-system";
          text = builtins.readFile ../scripts/remote-deployment-system.sh;
        };
        remoteDeploymentHome = pkgs.writeShellApplication {
          name = "remote-deployment-home";
          text = builtins.readFile ../scripts/remote-deployment-home.sh;
        };
        hibernateOnLowBattery = pkgs.writeShellApplication {
          name = "hibernate-on-low-battery";
          text = builtins.readFile ../scripts/hibernate_on_low_battery.sh;
        };
        restartFailedSystemdUserServices = pkgs.writeShellApplication {
          name = "restart-failed-systemd-user-services";
          text = builtins.readFile ../scripts/restart_failed_systemd_user_services.sh;
        };
        selectWallpaperImage = pkgs.writeShellApplication {
          name = "select-wallpaper-image";
          runtimeInputs = with pkgs; [
            imagemagick
            coreutils
          ];
          text = builtins.readFile ../scripts/select_wallpaper_image.sh;
        };
        updateWallpaperCaelestia = pkgs.writeShellApplication {
          name = "update-wallpaper-caelestia";
          text = builtins.readFile ../scripts/update_wallpaper_caelestia.sh;
        };
        updateWallpaperSwww = pkgs.writeShellApplication {
          name = "update-wallpaper-swww";
          text = builtins.readFile ../scripts/update_wallpaper_swww.sh;
        };
      };
    };
}
