{ userSettings, ... }:
let
  fontSize = if userSettings.isLinux then "11" else "13";
in
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
      config.font_size = ${fontSize}
      config.font = wezterm.font "JetBrainsMono Nerd Font"
      config.hide_tab_bar_if_only_one_tab = true
      config.window_background_opacity = 0.75
      config.macos_window_background_blur = 100
      config.kde_window_background_blur = true
      config.default_cursor_style = "BlinkingBar"
      config.cursor_blink_rate = 500
      config.enable_scroll_bar = true

      -- Finally, return the configuration to wezterm:
      return config
    '';
  };
}
