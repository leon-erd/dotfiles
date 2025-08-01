{ pkgs, ... }:

{
  imports = [
    ./xserver.nix
  ];

  environment.systemPackages = with pkgs; [
    (
      (sddm-astronaut.override {
        embeddedTheme = "pixel_sakura";
        themeConfig = {
          Background = "Backgrounds/my_background.mp4";
          HideVirtualKeyboard = false;
          HideSystemButtons = false;
        };
      }).overrideAttrs
      (prevAttrs: {
        installPhase = prevAttrs.installPhase + ''
          chmod u+w $out/share/sddm/themes/sddm-astronaut-theme/Backgrounds/
          cp ${../../../scripts/wallpaper/animated/mountains-in-clouds.1920x1080.mp4} $out/share/sddm/themes/sddm-astronaut-theme/Backgrounds/my_background.mp4
        '';
      })
    )
  ];

  services.displayManager.sddm = {
    enable = true;
    # package = pkgs.kdePackages.sddm;
    extraPackages = with pkgs; [
      kdePackages.qtmultimedia
    ];
    # to find theme name check out /etc/sddm.conf for "ThemeDir"
    # and then "ls <ThemeDir>"
    # probably "ls /run/current-system/sw/share/sddm/themes"
    theme = "sddm-astronaut-theme";
    wayland = {
      enable = true; # This is still experimental
      compositor = "kwin";
    };
  };
}
