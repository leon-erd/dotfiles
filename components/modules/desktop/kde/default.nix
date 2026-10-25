{ self, ... }:

{
  flake.modules.nixos.kde =
    { ... }:

    {
      imports = [
        self.modules.nixos.xserver
      ];

      services.desktopManager.plasma6.enable = true;
      # the plasma6 module sets itself as the default session which I don't want
      services.displayManager.defaultSession = null;
    };

  flake.modules.homeManager.kde =
    {
      config,
      inputs,
      pkgs,
      ...
    }:

    {
      imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

      home.packages = [ pkgs.layan-kde ];

      # https://github.com/nix-community/stylix/issues/267#issuecomment-2314636091
      programs.plasma = {
        enable = true;
        configFile.kded5rc = {
          "Module-gtkconfig"."autoload" = false;
        };
        # KWin default for all touchpads (plasma-manager's input.touchpads needs per-device ids)
        configFile.kcminputrc."Libinput/Defaults/Touchpad".NaturalScroll = true;

        # Ctrl+Alt+T opens WezTerm instead of Konsole (whose desktop file defines it as default)
        shortcuts = {
          "services/org.kde.konsole.desktop"._launch = [ ];
          "services/org.wezfurlong.wezterm.desktop"._launch = "Ctrl+Alt+T";
        };

        # Layan global theme, applied part by part instead of via lookAndFeel:
        # applying the global theme would override window decorations and splash on login
        workspace = {
          colorScheme = "Layan"; # from the theming module
          iconTheme = config.gtk.iconTheme.name;
          cursor = {
            theme = config.gtk.cursorTheme.name;
            size = config.gtk.cursorTheme.size;
          };
          theme = "Layan";
          # not via QT_STYLE_OVERRIDE: Qt Quick Controls would use it as its style name and plasmashell would not start
          widgetStyle = "kvantum";
          windowDecorations = {
            library = "org.kde.breeze";
            theme = "Breeze";
          };
          splashScreen = {
            engine = "KSplashQML";
            theme = "com.github.vinceliuice.Layan";
          };
        };
      };
    };
}
