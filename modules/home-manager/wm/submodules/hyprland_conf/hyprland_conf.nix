{ inputs, pkgs, ... }:

{
  imports = [
    ./bindings.nix
    ./env.nix
    ./exec-once.nix
    ./graphics.nix
    ./input.nix
    ./monitors.nix
    ./scratchpads.nix
    ./windowrules.nix
    ./workspacerules.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = ["--all"];
    package = inputs.hyprland.packages.${pkgs.system}.default;
  };
}
