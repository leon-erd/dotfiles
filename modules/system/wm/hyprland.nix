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

  # Optional, hint electron apps to use wayland:
  # crashes vscode though when menu bar not enabled (see github issue)
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Set this so that swaylock can unlock the screen with the correct pwassword
  security.pam.services.swaylock = {};

  # udev rules for swayosd
  services.udev.packages = [ pkgs.swayosd ];
}
