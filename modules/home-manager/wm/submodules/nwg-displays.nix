{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    nwg-displays
    wlr-randr
  ];

  wayland.windowManager.hyprland.settings = {
    source = [ "./monitors.conf" ];
    bind = [ "$mainMod, P, exec, nwg-displays" ];
  };

  home.activation = {
    myNwgDisplay =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run [ -f ~/.config/hypr/monitors.conf ] || touch ~/.config/hypr/monitors.conf
    '';
  };
}

