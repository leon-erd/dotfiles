{ ... }:

{
  imports = [
    ./bindings.nix
    ./env.nix
    ./exec-once.nix
    ./graphics.nix
    ./input.nix
    ./monitors.nix
    ./windowrules.nix
    ./workspacerules.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = ["--all"];
  };
}
