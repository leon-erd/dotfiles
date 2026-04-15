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
        nixos.hostBarbaraLaptopSystemConfig
        nixos.hostBarbaraLaptopSystemExtra

        # base
        nixos.locale
        nixos.nh
        system.settings
        nixos.settings
        nixos.users

        # boot
        nixos.grub

        # desktop
        nixos.fonts
        nixos.hyprland
        nixos.kde
        nixos.sddm

        # hardware
        nixos.acceleratedVideoPlayback
        nixos.automount
        nixos.bluetooth
        nixos.intel
        nixos.networking
        nixos.pipewire
        nixos.printing
        nixos.remote

        # security
        nixos.locationInformation
        nixos.runBinaries

        # shell
        system.cliApps
        nixos.cliApps

        nixos.virtualisation
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
          self.modules.generic.hostBarbaraLaptopUserConfig
          configCurrentUserOptions
          hostBarbaraLaptopHmExtra
          ./_mamas-packages.nix

          # apps
          firefox
          thunderbird
          office
          qtApps
          messenger

          # base
          base

          # desktop
          hyprland
          kde
          theming

          # devel
          alacritty
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
