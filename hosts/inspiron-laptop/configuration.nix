{ config, pkgs, inputs, systemSettings, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/basic
    ../../modules/system/apps/cli-apps.nix
    ../../modules/system/apps/virtualisation.nix
    ../../modules/system/boot/grub.nix
    #../../modules/system/boot/plymouth.nix
    ../../modules/system/fonts/fonts.nix
    ../../modules/system/hardware/accelerated_video_playback.nix
    ../../modules/system/hardware/automount.nix
    ../../modules/system/hardware/bluetooth.nix
    ../../modules/system/hardware/intel.nix
    ../../modules/system/hardware/networking.nix
    ../../modules/system/hardware/pipewire.nix
    #../../modules/system/hardware/power.nix
    ../../modules/system/hardware/printing.nix
    ../../modules/system/security/firewall.nix
    #../../modules/system/security/location_information.nix # https://github.com/NixOS/nixpkgs/issues/321121
    ../../modules/system/security/run_binaries.nix
    ../../modules/system/wm/sddm.nix
    ../../modules/system/wm/hyprland.nix
    #../../modules/system/wm/kde.nix # home-managers qt theming (in theming.nix) will fuck up plasma6 so you need to disable it if you want to try plasma6
  ];

  # install home-manager
  environment.systemPackages = with pkgs; [
    home-manager
  ];

  # create user
  users.users.${systemSettings.user1.username} = {
    isNormalUser = true;
    description = systemSettings.user1.name;
    extraGroups = [ "networkmanager" "wheel" "video" "libvirtd"];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
