{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    general = {
      gaps_in = 3;
      gaps_out = 3;
      border_size = 2;
      "col.active_border" = "rgba(33ccffff) rgba(00ff99ff) 45deg";
      "col.inactive_border" = "rgba(444444aa)";

      resize_on_border = true;

      layout = "master";
    };
    group = {
      "col.border_inactive" = "rgba(444444aa)";
      "col.border_active" = "rgba(8800ffff) rgba(aa0055ff) 45deg";
      groupbar = {
        "col.active" = "rgba(6600ccee)";
        "col.inactive" = "rgba(6600cc99)";
      };
    };

    bezier = [
      "linear, 0, 0, 1, 1"
    ];

    animation = [
      "borderangle, 1, 40, linear, loop"
      "layers, 1, 5, default, popin"
    ];

    decoration = {
      rounding = 5;
      blur = {
          size = 4;
          passes = 4;
          ignore_opacity = true;
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
