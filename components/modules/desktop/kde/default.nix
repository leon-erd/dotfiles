{ self, ... }:

{
  flake.modules.nixos.kde =
    { pkgs, ... }:

    {
      imports = [
        self.modules.nixos.xserver
      ];

      services.desktopManager.plasma6.enable = true;
      # the plasma6 module sets itself as the default session which I don't want
      services.displayManager.defaultSession = null;

      # the plasma6 module enables this by default (KMail, Kontact, Merkuro, ...)
      programs.kde-pim.enable = false;
      environment.plasma6.excludePackages = with pkgs.kdePackages; [
        konsole
        discover
        elisa
        khelpcenter
      ];
    };

  flake.modules.homeManager.kde =
    {
      config,
      inputs,
      pkgs,
      ...
    }:

    {
      imports = [
        inputs.plasma-manager.homeModules.plasma-manager
        self.modules.homeManager.wezterm
      ];

      home.packages = [ pkgs.layan-kde ];

      # Plasma has its own bluetooth applet. Overrides the autostart entry of blueman (services.blueman).
      xdg.configFile."autostart/blueman.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=Blueman Applet
        Exec=blueman-applet
        NotShowIn=KDE;
      '';

      # https://github.com/nix-community/stylix/issues/267#issuecomment-2314636091
      programs.plasma = {
        enable = true;
        configFile.kded5rc = {
          "Module-gtkconfig"."autoload" = false;
        };
        # KWin default for all touchpads (plasma-manager's input.touchpads needs per-device ids)
        configFile.kcminputrc."Libinput/Defaults/Touchpad".NaturalScroll = true;

        # disable baloo (file indexer)
        configFile.baloofilerc."Basic Settings"."Indexing-Enabled" = false;

        shortcuts."services/org.wezfurlong.wezterm.desktop"._launch = "Ctrl+Alt+T";

        # Terminal for desktop entries with Terminal=true (e.g. btop), otherwise KDE falls back to Konsole
        configFile.kdeglobals.General.TerminalApplication = "wezterm";

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

        # Plasma's default panel without "Peek at Desktop" (org.kde.plasma.showdesktop).
        panels = [
          {
            floating = true; # plasma-manager defaults to false
            widgets = [
              "org.kde.plasma.kickoff"
              "org.kde.plasma.pager"
              "org.kde.plasma.icontasks"
              "org.kde.plasma.marginsseparator"
              "org.kde.plasma.systemtray"
              {
                digitalClock.date = {
                  enable = false;
                  position = "belowTime";
                };
              }
            ];
          }
        ];
      };
    };
}
