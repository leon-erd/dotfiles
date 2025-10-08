{ self, ... }@inputs:

let
  myPkgs = import inputs.nixpkgs {
    overlays = [
      inputs.nur.overlays.default
      inputs.nix-vscode-extensions.overlays.default
    ];
    system = "aarch64-darwin";
    config.allowUnfree = true;
  };

  #pkgsLocal = import inputs.nixpkgsLocal {
  #  system = "aarch64-darwin";
  #  config.allowUnfree = true;
  #};

  userSettings1 = rec {
    username = "leon.erd"; # username
    name = "Leon Erd"; # name/identifier (used for certain configurations i.e. git)
    email = "leon.erd@zollsoft.de"; # email (used for certain configurations i.e. git)
    flakeDirectory = "/Users/${username}/dotfiles";
    systemConfigurationName = "zollsoft-mac";
    userConfigurationName = "${username}@zollsoft-mac";
    isLinux = myPkgs.stdenv.isLinux;
  };
in

{
  zollsoft-mac = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      ./configuration.nix
      {
        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;
      }
    ];
    specialArgs = {
      inherit inputs;
      inherit myPkgs;
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
