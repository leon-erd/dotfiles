{
  pkgs,
  inputs,
  systemSettings,
  ...
}:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
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
    ../../modules/system/security/remote.nix
    ../../modules/system/security/location_information.nix
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
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "libvirtd"
    ];
  };
  sops.secrets."ssh/private_keys/${systemSettings.user1.username}@${systemSettings.hostname}" = {
    owner = systemSettings.user1.username;
    mode = "600";
    path = "/home/${systemSettings.user1.username}/.ssh/id_ed25519";
  };

  sops = {
    age.keyFile = "/home/${systemSettings.user1.username}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
  };

  # for compiling through emulated system for raspberrypi
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  system.stateVersion = "23.11"; # Do not modify
}
