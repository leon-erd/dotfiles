{ self, ... }:

{
  flake.modules.nixos.base =
    { ... }:
    let
      inherit (self.lib) resolveSystemModules;
    in
    {
      imports = resolveSystemModules "nixos" (
        with self.modules;
        [
          nixos.kernel
          nixos.locale
          nixos.nh
          system.settings
          nixos.settings
          nixos.sops
          nixos.users
        ]
      );
    };

  flake.modules.homeManager.base =
    { config, ... }:

    {
      imports = with self.modules.homeManager; [
        sops
      ];

      # Home Manager needs a bit of information about you and the paths it should
      # manage.
      home.username = config.myUserConfig.username;
      home.homeDirectory = "/home/${config.myUserConfig.username}";
      xdg.enable = true;

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
    };
}
