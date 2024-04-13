{ pkgs, systemSettings, userSettings, ... }:

{
  imports = [
    ./xserver.nix
  ];

  environment.systemPackages = with pkgs; [
    ((sddm-chili-theme.overrideAttrs (previousAttrs: {
      postInstall = ''
        mkdir -p $out/share/sddm/themes/chili
        mv * $out/share/sddm/themes/chili/
        cp ${../../../scripts/wallpaper/wallpaper.jpg} $out/share/sddm/themes/chili/assets/my_wallpaper.jpg
      '';
    })).override {
      themeConfig = {
        background = "assets/my_wallpaper.jpg";
        blur = true;
      };
    })
  ];

  services.displayManager.sddm = {
    enable = true;
    theme = "chili";
    #wayland.enable = true; # This is still experimental. I think bc of this I get dropped into tty sometimes instead of Hyprland
  };
}
