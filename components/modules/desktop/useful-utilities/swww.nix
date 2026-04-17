{ self, ... }:

{
  flake.modules.homeManager.swww =
    { pkgs, config, ... }:

    {
      home.packages = [ pkgs.swww ];
      wayland.windowManager.hyprland.settings = {
        bind = [
          "CTRL + ALT, W, exec, ${
            self.packages.${pkgs.stdenv.hostPlatform.system}.selectWallpaperImage
          } ${config.myUserConfig.wallpaperFolder} && ${
            self.packages.${pkgs.stdenv.hostPlatform.system}.updateWallpaperSwww
          } --fallback ${../../../wallpaper/fallback.jpg}"
        ];
        exec-once = [
          "sleep 1 && swww-daemon"
          "sleep 2 && ${
            self.packages.${pkgs.stdenv.hostPlatform.system}.updateWallpaperSwww
          } --fallback ${../../../wallpaper/fallback.jpg}"
        ];
      };
    };
}
