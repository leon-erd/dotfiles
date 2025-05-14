{ inputs, ... }:

{
  imports = [
    inputs.grub2-themes.nixosModules.default
  ];

  # Bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
    };
    grub2-theme = {
      # checkout https://github.com/vinceliuice/grub2-themes/blob/master/flake.nix for more options
      enable = true;
      theme = "tela";
      icon = "color";
      splashImage = ../../../scripts/wallpaper/wallpaper_blurred.jpg;
    };
  };
}
