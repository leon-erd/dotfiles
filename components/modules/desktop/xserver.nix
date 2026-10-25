{ ... }:

{
  flake.modules.nixos.xserver =
    { config, pkgs, ... }:

    {
      # Enable the X11 windowing system and configure keymap in X11
      services.xserver = {
        enable = true;
        xkb.layout = config.mySystemConfig.kblayout;
        excludePackages = [ pkgs.xterm ];
      };
    };
}
