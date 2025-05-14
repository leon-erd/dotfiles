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
      font.normal.family = "HackNerdFontMono";
    };
  };

  wayland.windowManager.hyprland.settings = {
    bind = [ "CTRL + ALT, T, exec, alacritty" ];
  };
}
