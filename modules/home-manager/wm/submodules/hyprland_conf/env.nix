{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    env = [
      # Some default env vars.
      "XCURSOR_SIZE, 12"
      "QT_QPA_PLATFORMTHEME, qt5ct"
      #"GTK_THEME, Layan-Dark-Solid"
    ];
  };
}
