{
  description = "Leons Flake for Raspberry Pi Server";

  outputs =
    { self, ... }@inputs:

    let
      systemSettings = rec {
        hostname = "raspberrypi"; # hostname, unique identifier for building the flake
        timezone = "Europe/Vienna"; # timezone
        defaultLocale = "en_US.UTF-8"; # default locale
        extraLocale = "de_AT.UTF-8"; # extra locale (for measurement, numeric, time, ...)
        kblayout = "de"; # keyboard layout
        user1 = {
          username = userSettings1.username; # username
          name = userSettings1.name;
        };
        localIp = "192.168.179.200";
        nextcloud = {
          drives = {
            main = "usb-TOSHIBA_External_USB_3.0_20200714006512F-0:0-part1";
            backup = "usb-Intenso_External_USB_3.0_20161230160B8-0:0-part1";
          };
          hostName = "amysweinhaus.ddnss.de";
          trusted_domains = [
            localIp
          ];
        };
        acmeEmail = "leonvincenterd@web.de";
        pihole.hosts = [
          "${localIp} ${nextcloud.hostName}"
        ];
        wireguard = {
          externalInterface = "enu1u1u1"; # use "ip a"
          clientPeers = [
            {
              name = "inspiron-laptop";
              publicKey = "dLHb13EIwUM1HJoEPojOskp18c87Ciu/ZYUZmIkQMBA=";
              allowedIPs = [ "10.100.0.2/32" ];
            }
            {
              name = "leon-handy";
              publicKey = "ahgGz2HSN6L0SaA85tEUccSogdu/6XCOJKsS0XyI238=";
              allowedIPs = [ "10.100.0.3/32" ];
            }
          ];
        };
      };

      userSettings1 = rec {
        username = "leon"; # username
        name = "Leon"; # name/identifier (used for certain configurations i.e. git)
        email = "leonvincenterd@web.de"; # email (used for certain configurations i.e. git)
        flakeDirectory = "/home/${username}/dotfiles/hosts/raspberrypi";
        kblayout = "de";
        systemConfigurationName = systemSettings.hostname;
        userConfigurationName = "${username}@${systemConfigurationName}";
      };

      myPkgs = import inputs.nixpkgs {
        system = "aarch64-linux"; # system arch (checkout hardware-configuration.nix -> nixpkgs.hostPlatform);
        config.allowUnfree = true;
      };
    in

    {
      nixosConfigurations.${systemSettings.hostname} = inputs.nixpkgs.lib.nixosSystem {
        modules = [ ./configuration.nix ];
        specialArgs = {
          inherit inputs;
          inherit myPkgs;
          inherit systemSettings;
        };
      };

      homeConfigurations.${userSettings1.userConfigurationName} =
        inputs.home-manager.lib.homeManagerConfiguration
          {
            pkgs = myPkgs;
            modules = [ ./home.nix ];
            extraSpecialArgs = {
              # pass config variables from above
              inherit inputs;
              userSettings = userSettings1;
              #inherit pkgsLocal;
            };
          };
    };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
