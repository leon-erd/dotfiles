{ self, ... }@inputs:

let
  systemSettings = {
    hostname = "mamas-laptop"; # hostname, unique identifier for building the flake
    timezone = "Europe/Vienna"; # timezone
    defaultLocale = "de_AT.UTF-8"; # default locale
    extraLocale = "de_AT.UTF-8"; # extra locale (for measurement, numeric, time, ...)
    kblayout = "de"; # keyboard layout
    users = {
      "1" = {
        username = userSettings1.username; # username
        name = userSettings1.name;
        extraGroups = [
          "networkmanager"
          "scanner"
          "wheel"
          "video"
          "libvirtd"
        ];
      };
    };
  };

  userSettings1 = rec {
    username = "barbara"; # username
    name = "Leon"; # name/identifier (used for certain configurations i.e. git)
    email = "leonvincenterd@web.de"; # email (used for certain configurations i.e. git)
    flakeDirectory = "/home/${username}/dotfiles";
    kblayout = "de";
    systemConfigurationName = systemSettings.hostname;
    userConfigurationName = "${username}@${systemConfigurationName}";
    isLinux = myPkgs.stdenv.isLinux;
  };

  myPkgs = import inputs.nixpkgs {
    overlays = [
      inputs.nur.overlays.default
      inputs.nix-vscode-extensions.overlays.default
      (import ../../overlays)
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
