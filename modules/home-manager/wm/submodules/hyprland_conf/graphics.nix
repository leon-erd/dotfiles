{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    general = {
      gaps_in = 3;
      gaps_out = 3;
      border_size = 2;
      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      "col.inactive_border" = "rgba(595959aa)";

      resize_on_border = true;

      layout = "master";
    };

    decoration = {
      rounding = 5;
      blur = {
          size = 4;
          passes = 4;
          popups = true;
      };
    };

    misc = {
      animate_manual_resizes = true;
      animate_mouse_windowdragging = true;
      force_default_wallpaper = 0;
    };

    dwindle = {
      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
      preserve_split = true; # you probably want this
      force_split = 2;
    };

    master = {
      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      new_is_master = false;
    };
  };
}
