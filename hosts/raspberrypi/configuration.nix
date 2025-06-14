{ inputs, systemSettings, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./hardware-configuration.nix
    ../../modules/system/apps/cli-apps.nix
    ../../modules/system/basic
    ../../modules/system/server/nextcloud
    ../../modules/system/server/pihole.nix
    ../../modules/system/server/wireguard.nix
    ../../modules/system/server/fail2ban.nix
  ];

  # Setup ssh and remote deployment from leon@inspiron-laptop
  users.users.${systemSettings.users."1".username} = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM22vgwjJ9HTFLvJTyQcyq4sgEFzI6jAS2FX6aB7AXVK leon@inspiron-laptop"
    ];
  };
  nix.settings.trusted-users = [ systemSettings.users."1".username ];
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      AllowUsers = [ systemSettings.users."1".username ];
      PasswordAuthentication = false;
    };
  };

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # Networking configuration
  networking.hostName = systemSettings.hostname;
  networking.wireless.enable = false; # Enables wireless support via wpa_supplicant.

  # Static IP configuration
  networking.interfaces.enu1u1u1 = {
    useDHCP = false;
    ipv4.addresses = [
      {
        address = systemSettings.localIp;
        prefixLength = 24;
      }
    ];
  };
  networking.defaultGateway = {
    address = "192.168.179.1";
    interface = "enu1u1u1";
  };
  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
  ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 4096; # size in MB
    }
  ];

  system.stateVersion = "24.11"; # Do not modify
}
