{ ... }:

{
  imports = [
    ./bindings.nix
    ./exec-once.nix
    ./graphics.nix
    ./input.nix
    ./layouts.nix
    ./misc.nix
    ./monitors.nix
    ./scratchpads.nix
    ./windowrules.nix
    ./workspacerules.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = [ "--all" ];
    package = null;
    portalPackage = null;
  };
}
