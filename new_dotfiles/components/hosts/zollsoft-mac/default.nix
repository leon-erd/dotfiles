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
  flake.darwinConfigurations.${hostSettings.systemConfigurationName} =
    inputs.nix-darwin.lib.darwinSystem
      {
        modules = resolveSystemModules "darwin" (
          with self.modules;
          [
            darwin.hostZollsoftMacSystemConfig
            darwin.hostZollsoftMacSystemExtra

            # base
            darwin.macosSettings
            system.cliApps
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
          self.modules.generic.hostZollsoftMacUserConfig
          configCurrentUserOptions
          hostZollsoftMacHmExtra

          # apps
          thunderbird
          appsMisc

          # desktop
          aerospace
          karabiner
          autoraise

          # devel
          git
          python
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
