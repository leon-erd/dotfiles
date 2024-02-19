{ systemSettings, ... }:

{
  # Enable the X11 windowing system and configure keymap in X11
  services.xserver = {
    enable = true;
    xkb.layout = systemSettings.kblayout;
  };
}
