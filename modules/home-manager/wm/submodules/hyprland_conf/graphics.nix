{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    general = {
      gaps_in = 3;
      gaps_out = 3;
      border_size = 2;
      "col.active_border" = "rgba(33ccffff) rgba(00ff99ff) 45deg";
      "col.inactive_border" = "rgba(444444aa)";
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
  };
}
