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
        nixos.hostRaspberrypiSystemConfig
        nixos.hostRaspberrypiSystemExtra

        # base
        nixos.base

        # server
        nixos.fail2ban
        nixos.nextcloud
        nixos.pihole
        nixos.wireguard

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
          self.modules.generic.hostRaspberrypiUserConfig
          configCurrentUserOptions
          hostRaspberrypiHmExtra

          # base
          base

          # devel
          git

          # shell
          shell
        ];
        extraSpecialArgs = {
          inherit inputs;
        };
      };
}
