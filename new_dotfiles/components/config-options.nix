{ ... }:

{
  flake.modules.generic.configSystemOptions =
    { lib, ... }:

    let
      inherit (lib.types)
        listOf
        nullOr
        str
        submodule
        ;
      inherit (lib.options) mkOption;
    in
    {
      options.mySystemConfig = {
        hostname = mkOption {
          type = str;
          description = "Hostname, unique identifier for building the flake";
          example = "inspiron-laptop";
        };
        timezone = mkOption {
          type = str;
          default = "Europe/Vienna";
        };
        defaultLocale = mkOption {
          type = str;
          default = "en_US.UTF-8";
        };
        extraLocale = mkOption {
          type = str;
          default = "de_AT.UTF-8";
          description = "Extra locale (for measurement, numeric, time, …)";
        };
        kblayout = mkOption {
          type = str;
          default = "de";
          description = "Keyboard layout";
        };
        localIp = mkOption {
          type = str;
          description = "Local IP address of the machine";
          example = "192.168.179.200";
        };
        acmeEmail = mkOption {
          type = str;
          description = "Email address for ACME/Let's Encrypt certificates";
        };
        nextcloud = {
          drives = {
            main = mkOption {
              type = str;
              description = "udev disk ID for the main Nextcloud drive";
              example = "usb-TOSHIBA_External_USB_3.0_20200714006512F-0:0-part1";
            };
            backup = mkOption {
              type = str;
              description = "udev disk ID for the Nextcloud backup drive";
              example = "usb-Intenso_External_USB_3.0_20161230160B8-0:0-part1";
            };
          };
          hostName = mkOption {
            type = str;
            description = "Public hostname for the Nextcloud instance";
            example = "cloud.example.com";
          };
          trustedDomains = mkOption {
            type = listOf str;
            description = "Additional trusted domains for Nextcloud";
            example = [ "192.168.179.200" ];
          };
        };
        pihole = {
          hosts = mkOption {
            type = listOf str;
            default = [ ];
            description = "Extra host entries for Pi-hole";
            example = [ "192.168.179.200 raspberry.pi" ];
          };
        };
        wireguard = {
          externalInterface = mkOption {
            type = str;
            description = "Network interface facing the internet (use `ip a`)";
            example = "enu1u1u1";
          };
          clientPeers = mkOption {
            type = listOf (submodule {
              options = {
                name = mkOption { type = str; };
                publicKey = mkOption { type = str; };
                allowedIPs = mkOption { type = listOf str; };
              };
            });
            default = [ ];
            description = "WireGuard client peers";
            example = [
              {
                name = "laptop";
                publicKey = "dLHb13EIwUM1HJoEPojOskp18c87Ciu/ZYUZmIkQMBA=";
                allowedIPs = [ "10.100.0.2/32" ];
              }
            ];
          };
        };
      };
    };

  flake.modules.generic.configUserOptions =
    { lib, config, ... }:

    let
      inherit (lib.types)
        listOf
        path
        str
        submodule
        ;
      inherit (lib.options) mkOption;

      user = submodule {
        options = {
          username = mkOption {
            type = str;
          };
          systemConfigurationName = mkOption {
            type = str;
            description = "Name of the NixOS configuration this user belongs to";
          };
          userConfigurationName = mkOption {
            type = str;
            description = "Key used in homeConfigurations, typically username@systemConfigurationName";
            default = "${config.username}@${config.systemConfigurationName}";
            defaultText = lib.literalExpression ''"''${config.username}@''${config.systemConfigurationName}"'';
          };
          name = mkOption {
            type = str;
            description = "Display name, used for e.g. git";
          };
          email = mkOption {
            type = str;
            description = "Email address, used for e.g. git";
          };
          extraGroups = mkOption {
            type = listOf str;
            default = [
              "networkmanager"
              "wheel"
              "video"
              "libvirtd"
            ];
          };
          kblayout = mkOption {
            type = str;
            default = "de";
            description = "Keyboard layout";
          };
          flakeDirectory = mkOption {
            type = str;
            description = "Absolute path to the dotfiles flake on the machine";
            example = "/home/leon/dotfiles";
          };
          wallpaperFolder = mkOption {
            type = str;
            description = "Absolute path to the wallpaper folder";
            example = "/home/leon/Nextcloud/Pictures";
          };
          wireguardConfig = mkOption {
            type = path;
            description = "Path to the WireGuard client config file";
            example = lib.literalExpression ''../secrets/files/wireguard_clients/my-wireguard.conf'';
          };
        };
      };
    in
    {
      options.myUsers = mkOption {
        type = listOf user;
        description = "List of users";
      };
    };

  flake.modules.homeManager.configCurrentUserOptions =
    { config, lib, ... }:
    {
      options.myUserConfig = lib.mkOption {
        type = lib.types.unspecified;
        description = "The user config of the current user, automatically set by the home manager configuration";
      };
      config.myUserConfig = lib.mkDefault (lib.head config.myUsers);
    };
}
