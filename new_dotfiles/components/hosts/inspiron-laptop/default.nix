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
        nixos.hostInspironLaptopSystemConfig
        nixos.hostInspironLaptopSystemExtra

        # base
        nixos.base

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
        # setup pkgs: use preconfigured pkgs for the current system
        pkgs = withSystem hostSettings.system (
          { pkgs, ... }: pkgs # perSystem module arguments
        );
        modules = with self.modules.homeManager; [
          self.modules.generic.hostInspironLaptopUserConfig
          configCurrentUserOptions

          # apps
          media
          firefox
          thunderbird
          office
          qtApps
          messenger
          appsMisc

          # base
          base

          # desktop
          hyprland
          kde
          theming

          # devel
          alacritty
          git
          latex
          python
          vscode
          wezterm

          # shell
          shell
          wireguardClient

          virtualisation
          hostInspironLaptopHmExtra
        ];
        extraSpecialArgs = {
          inherit inputs;
        };
      };
}
