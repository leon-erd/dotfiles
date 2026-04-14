{ ... }:
{
  flake.modules.nixos.hostRaspberrypiSystemExtra =
    { config, ... }:
    let
      username = (builtins.head config.myUsers).username;
    in
    {
      # SSH access for remote deployment from leon@inspiron-laptop
      users.users.${username} = {
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM22vgwjJ9HTFLvJTyQcyq4sgEFzI6jAS2FX6aB7AXVK leon@inspiron-laptop"
        ];
      };
      nix.settings.trusted-users = [ username ];

      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "no";
          AllowUsers = [ username ];
          PasswordAuthentication = false;
        };
      };

      # Use extlinux bootloader (NixOS wants to enable GRUB by default)
      boot.loader.grub.enable = false;
      # Enables the generation of /boot/extlinux/extlinux.conf
      boot.loader.generic-extlinux-compatible.enable = true;

      # Networking configuration
      networking.hostName = config.mySystemConfig.hostname;
      networking.wireless.enable = false;

      # Static IP configuration
      networking.interfaces.enu1u1u1 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = config.mySystemConfig.localIp;
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
    };

  flake.modules.homeManager.hostRaspberrypiHmExtra =
    { ... }:
    {
      home.stateVersion = "24.11"; # Do not modify
    };
}