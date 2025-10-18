{ ... }:

{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      -- Pull in the wezterm API
      local wezterm = require 'wezterm'

      -- This will hold the configuration.
      local config = wezterm.config_builder()

      -- This is where you actually apply your config choices.

      -- or, changing the font size and color scheme.
      config.font_size = 13
      -- config.font = wezterm.font "Hack Nerd Font Mono"
      config.hide_tab_bar_if_only_one_tab = true
      config.window_background_opacity = 0.8
      config.macos_window_background_blur = 100
      config.kde_window_background_blur = true
      config.default_cursor_style = "BlinkingBar"
      config.cursor_blink_rate = 500
      config.enable_scroll_bar = true

      -- Finally, return the configuration to wezterm:
      return config
    '';
  };

  wayland.windowManager.hyprland.settings = {
    bind = [ "CTRL + ALT, T, exec, alacritty" ];
  };
}
