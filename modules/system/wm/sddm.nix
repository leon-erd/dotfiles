{ pkgs, systemSettings, ... }:

{
  imports = [
    ./xserver.nix
  ];

  environment.systemPackages = with pkgs; [
    sddm-chili-theme
  ];

  services.xserver.displayManager.sddm = {
    enable = true;
    theme = "chili";
    #wayland.enable = true; # This is still experimental. I think bc of this I get dropped into tty sometimes instead of Hyprland
  };
}
