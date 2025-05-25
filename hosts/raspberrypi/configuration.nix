{
  pkgs,
  inputs,
  systemSettings,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/apps/cli-apps.nix
    ../../modules/system/basic
    ../../modules/system/security/firewall.nix
    ../../modules/system/server/nextcloud/nextcloud.nix
    inputs.sops-nix.nixosModules.sops
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
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCuv6vNZSzXfzD5NwqJbvOn1kJlN1IUSFulqsANyUv+pYzkZGQo6ug75ZLhH/eZQlGlweX5C0NBfWZQ0b3Qnc7ZRjD5Tnp0UMXnuSvgw9Av/g3fvdZlY94RiIhxviqecFmkrdX7nAqQrwc7tc8ny7tZDS45t1VbtZuRxAPEMaMDrTYWKhVCUVF4QosT8VAGgQr8SzjPOe6UDjxJh0isgiFqJOY8d/Gzg4XaXXFI8LiqI/p0vyvc3Aw+UOtxqVuun6+sxW2BWO6OTjHUJZKrs7Of0J5HnbJPlt7Jgse+mmjEVj+gADgsaa90g+kJ5xCdPuZD7XzmM19NmvWIrhZBFPy6pk14BBrpDLIChpjtJyMVwCxANw3RIRTMEFbeZD9bb3r9ghp0sSWO4Mgl6AHD41cMGbNGo6z0+bOqFXCKoUS6Jfkv9La/9Ytc8iqq/vEjDllh/CeN029gWWlcs9onXqWtU9BnSYTV8X/ti3fAWCLz+WH8c11wh1gzMFFP3ft0aHM= leon@leon-inspiron"
    ];
  };
  services.openssh.enable = true;
  nix.settings.trusted-users = [ systemSettings.user1.username ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = systemSettings.hostname;
  networking.wireless.enable = false; # Enables wireless support via wpa_supplicant.

  swapDevices = [
    {
      device = "/swapfile";
      size = 4096; # size in MB
    }
  ];

  sops.age.keyFile = "/home/${systemSettings.user1.username}/.config/sops/age/keys.txt";
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  system.stateVersion = "24.11"; # Do not modify
}
