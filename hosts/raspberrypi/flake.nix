{
  description = "Leons Flake for Raspberry Pi Server";

  outputs =
    { self, ... }@inputs:

    let
      systemSettings = {
        hostname = "raspberrypi"; # hostname, unique identifier for building the flake
        timezone = "Europe/Vienna"; # timezone
        defaultLocale = "en_US.UTF-8"; # default locale
        extraLocale = "de_AT.UTF-8"; # extra locale (for measurement, numeric, time, ...)
        kblayout = "de"; # keyboard layout
        user1 = {
          username = userSettings1.username; # username
          name = userSettings1.name;
        };
        nextcloud = {
          drives = {
            main = "usb-TOSHIBA_External_USB_3.0_20200714006512F-0:0-part1";
            backup = "usb-Intenso_External_USB_3.0_20161230160B8-0:0-part1";
          };
          hostName = "amysweinhaus.ddnss.de";
          trusted_domains = [
            "10.10.10.100"
          ];
        };
        acmeEmail = "leonvincenterd@web.de";
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
    nixpkgs.url = "nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
