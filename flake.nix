{
  description = "Leons Flake for NixOS and Home Manager configuration";

  outputs = { self, ... }@inputs:
  let
    # ---- SYSTEM SETTINGS ---- #
    systemSettings = {
      system = "x86_64-linux";        # system arch (checkout hardware-configuration.nix -> nixpkgs.hostPlatform)
      hostname = "leon-inspiron";     # hostname
      host = "inspiron-laptop";       # select a host defined in hosts directory
      timezone = "Europe/Vienna";     # timezone
      defaultLocale = "en_US.UTF-8";  # default locale
      extraLocale = "de_AT.UTF-8";    # extra locale (for measurement, numeric, time, ...)
      kblayout = "de";                # keyboard layout
    };

    # ----- USER SETTINGS ----- #
    userSettings = {
      username = "leon";                      # username
      name = "Leon";                          # name/identifier (used for certain configurations i.e. git)
      email = "leon.erd@student.uibk.ac.at";  # email (used for certain configurations i.e. git)
      flakeDirectory = "~/Nextcloud/dotfiles";
    };

    # configure packages
    pkgs = import inputs.nixpkgs {
      overlays = [
        inputs.nur.overlay
      ];
      system = systemSettings.system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      system = inputs.nixpkgs.lib.nixosSystem {
        system = systemSettings.system;
        modules = [ (./. + "/hosts/${systemSettings.host}/configuration.nix") ]; # load configuration.nix from selected host
        specialArgs = {
          inherit pkgs;
          inherit inputs;
          inherit systemSettings;
          inherit userSettings;
        };
      };
    };
    homeConfigurations = {
      user = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ (./. + "/hosts/${systemSettings.host}/home.nix") ]; # load home.nix from selected host
        extraSpecialArgs = {
          # pass config variables from above
          inherit inputs;
          inherit systemSettings;
          inherit userSettings;
        };
      };
    };
  };

  inputs = {
    #nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      #url = "github:nix-community/home-manager/release-23.11";
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    # Do not override Hyprland’s nixpkgs input. Doing so will make the cache useless, since you’re building from a different Nixpkgs commit.
    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      #url = "git+file:///home/leon/Downloads/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

