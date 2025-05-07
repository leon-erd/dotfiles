{self, ...}@inputs:

let
  systemSettings = {
    hostname = "inspiron-laptop"; # hostname, unique identifier for building the flake
    timezone = "Europe/Vienna"; # timezone
    defaultLocale = "en_US.UTF-8"; # default locale
    extraLocale = "de_AT.UTF-8"; # extra locale (for measurement, numeric, time, ...)
    kblayout = "de"; # keyboard layout
    user1 = {
      username = userSettings1.username; # username
      name = userSettings1.name;
    };
  };

  userSettings1 = rec {
    username = "leon"; # username
    name = "Leon"; # name/identifier (used for certain configurations i.e. git)
    email = "leonvincenterd@web.de"; # email (used for certain configurations i.e. git)
    flakeDirectory = "/home/${username}/Nextcloud/dotfiles";
    kblayout = "de";
    systemConfigurationName = systemSettings.hostname;
    userConfigurationName = "${username}@${systemConfigurationName}";
  };

  myPkgs = import inputs.nixpkgs {
    overlays = [
      inputs.nur.overlays.default
      inputs.nix-vscode-extensions.overlays.default
    ];
    system = "x86_64-linux"; # system arch (checkout hardware-configuration.nix -> nixpkgs.hostPlatform);
    config.allowUnfree = true;
  };

  #pkgsLocal = import inputs.nixpkgsLocal {
  #  system = "x86_64-linux"; # system arch (checkout hardware-configuration.nix -> nixpkgs.hostPlatform);
  #  config.allowUnfree = true;
  #};
in

{
  ${systemSettings.hostname} = inputs.nixpkgs.lib.nixosSystem {
    modules = [ ./configuration.nix ];
    specialArgs = {
      inherit inputs;
      inherit myPkgs;
      inherit systemSettings;
    };
  };

  ${userSettings1.userConfigurationName} = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = myPkgs;
    modules = [ ./home.nix ];
    extraSpecialArgs = {
      # pass config variables from above
      inherit inputs;
      userSettings = userSettings1;
      #inherit pkgsLocal;
    };
  };
}
