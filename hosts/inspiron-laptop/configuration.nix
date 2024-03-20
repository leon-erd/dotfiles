{ config, pkgs, inputs, systemSettings, userSettings, ... }:

{
  imports =
    [ ./hardware-configuration.nix
      ../../modules/system/apps/cli-apps.nix
      ../../modules/system/apps/virtualisation.nix
      ../../modules/system/boot/grub.nix
      #../../modules/system/boot/plymouth.nix
      ../../modules/system/fonts/fonts.nix
      ../../modules/system/hardware/automount.nix
      ../../modules/system/hardware/bluetooth.nix
      ../../modules/system/hardware/networking.nix
      ../../modules/system/hardware/pipewire.nix
      ../../modules/system/hardware/power.nix
      ../../modules/system/hardware/printing.nix
      ../../modules/system/security/firewall.nix
      ../../modules/system/security/run_binaries.nix
      ../../modules/system/wm/sddm.nix
      ../../modules/system/wm/hyprland.nix
      #../../modules/system/wm/kde.nix
    ];

  # set some important things
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware  = true; # Enable all firmware regardless of license
  console.keyMap = systemSettings.kblayout; # tty keyboard layout
  boot.kernelPackages = pkgs.linuxPackages_latest; # get latest stable kernel
  nix.optimise.automatic = true; # optimise nix store disk space by hard linking identical files

  # install home-manager
  environment.systemPackages = with pkgs; [
    home-manager
  ];

  # set locales
  time.timeZone = systemSettings.timezone;
  i18n.defaultLocale = systemSettings.defaultLocale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = systemSettings.extraLocale;
    LC_IDENTIFICATION = systemSettings.extraLocale;
    LC_MEASUREMENT = systemSettings.extraLocale;
    LC_MONETARY = systemSettings.extraLocale;
    LC_NAME = systemSettings.extraLocale;
    LC_NUMERIC = systemSettings.extraLocale;
    LC_PAPER = systemSettings.extraLocale;
    LC_TELEPHONE = systemSettings.extraLocale;
    LC_TIME = systemSettings.extraLocale;
  };

  # create user
  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = [ "networkmanager" "wheel" "video" "libvirtd"];
  };

  # set zsh as default shell
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
