 { ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      cursor.style = {
        blinking = "On";
        shape = "Beam";
      };
      selection.save_to_clipboard = true;
      window.opacity = 0.75;
    };
  };

  wayland.windowManager.hyprland.settings = {
    bind = [ "CTRL + ALT, T, exec, alacritty" ];
  };
}
