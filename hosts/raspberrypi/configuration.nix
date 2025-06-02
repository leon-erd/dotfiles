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
    ../../modules/system/apps/cli-apps.nix
    ../../modules/system/basic
    ../../modules/system/server/nextcloud/nextcloud.nix
    ../../modules/system/server/wireguard.nix
    ../../modules/system/server/fail2ban.nix
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
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM22vgwjJ9HTFLvJTyQcyq4sgEFzI6jAS2FX6aB7AXVK leon@inspiron-laptop"
    ];
  };
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      AllowUsers = [ systemSettings.user1.username ];
      PasswordAuthentication = false;
    };
  };
  sops.secrets."ssh/private_keys/${systemSettings.user1.username}@${systemSettings.hostname}" = {
    owner = systemSettings.user1.username;
    mode = "600";
    path = "/home/${systemSettings.user1.username}/.ssh/id_ed25519";
  };
  nix.settings.trusted-users = [ systemSettings.user1.username ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = systemSettings.hostname;
  networking.wireless.enable = false; # Enables wireless support via wpa_supplicant.

  # static IP configuration
  networking.interfaces.enu1u1u1 = {
    useDHCP = false;
    ipv4.addresses = [
      {
        address = "192.168.179.200";
        prefixLength = 24;
      }
    ];
  };
  networking.defaultGateway = {
    address = "192.168.179.1";
    interface = "enu1u1u1";
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 4096; # size in MB
    }
  ];

  sops = {
    age.keyFile = "/home/${systemSettings.user1.username}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
  };

  system.stateVersion = "24.11"; # Do not modify
}
