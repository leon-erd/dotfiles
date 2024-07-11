{ pkgs, inputs, ... }:

{
  imports = [
    ./gnome-keyring.nix
  ];

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  xdg.portal = {
    extraPortals = [
      (pkgs.xdg-desktop-portal-wlr.overrideAttrs (previousAttrs: rec {
        src = pkgs.fetchFromGitHub {
          owner = "leon-erd";
          repo = "xdg-desktop-portal-wlr";
          rev = "424287fa0b2c59096e38534efdbd9a6bec13aead";
          sha256 = "sha256-4igGdq8CpWbTmDVVKZwIs76eOTESDrGO5qa0m/BhYP4=";
        };
        buildInputs = previousAttrs.buildInputs ++ [ pkgs.libxkbcommon ];
      }))
    ];
  };

  # Optional, hint electron apps to use wayland:
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # udev rules for swayosd
  services.udev.packages = [ pkgs.swayosd ];
}
