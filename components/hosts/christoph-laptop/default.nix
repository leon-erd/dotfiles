{
  self,
  withSystem,
  inputs,
  ...
}:
let
  hostSettings = import ./_settings-base.nix;
  inherit (self.lib) resolveSystemModules;
in
{
  flake.nixosConfigurations.${hostSettings.systemConfigurationName} = inputs.nixpkgs.lib.nixosSystem {
    modules = resolveSystemModules "nixos" (
      with self.modules;
      [
        # setup pkgs: use preconfigured pkgs for the current system
        inputs.nixpkgs.nixosModules.readOnlyPkgs
        {
          nixpkgs.pkgs = withSystem hostSettings.system (
            { pkgs, ... }: pkgs # perSystem module arguments
          );
        }

        ./_hardware-configuration.nix
        nixos.hostChristophLaptopSystemConfig
        nixos.hostChristophLaptopSystemExtra

        # base
        nixos.kernel
        nixos.locale
        nixos.nh
        system.settings
        nixos.settings
        nixos.users

        # boot
        nixos.grub

        # desktop
        nixos.fonts
        nixos.kde
        nixos.sddm

        # hardware
        nixos.acceleratedVideoPlayback
        nixos.automount
        nixos.bluetooth
        nixos.intel
        nixos.networking
        nixos.locationInformation
        nixos.pipewire
        nixos.printing

        # security
        nixos.remote
        nixos.runBinaries

        # shell
        system.cliApps
        nixos.cliApps
      ]
    );
    specialArgs = {
      inherit inputs;
    };
  };

  flake.homeConfigurations.${hostSettings.userConfigurationName} =
    inputs.home-manager.lib.homeManagerConfiguration
      {
        pkgs = withSystem hostSettings.system (
          { pkgs, ... }: pkgs # perSystem module arguments
        );
        modules = with self.modules.homeManager; [
          self.modules.generic.hostChristophLaptopUserConfig
          configCurrentUserOptions
          hostChristophLaptopHmExtra
          ./_papas-packages.nix

          # apps
          firefox
          thunderbird
          office
          qtApps

          # base
          base

          # desktop
          kde
          theming

          # devel
          git
          vscode
          wezterm

          # shell
          shell
        ];
        extraSpecialArgs = {
          inherit inputs;
        };
      };
}
