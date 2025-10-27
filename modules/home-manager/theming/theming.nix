{ pkgs, ... }:

{
  gtk = {
    enable = true;
    theme = {
      package = pkgs.layan-gtk-theme;
      name = "Layan-Dark";
    };
    cursorTheme = {
      package = pkgs.kdePackages.breeze-gtk;
      name = "breeze_cursors";
      size = 24;
    };
    iconTheme = {
      package = pkgs.tela-icon-theme;
      name = "Tela";
    };
    font = {
      name = "NotoSansNerdFont";
      size = 10;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    # style.name = "kvantum"; # this sets QT_STYLE_OVERRIDE=kvantum which fucks up plasma6. Disable this line if you want to use kde *)
    style.package = with pkgs; [
      libsForQt5.qtstyleplugin-kvantum
      qt6Packages.qtstyleplugin-kvantum
    ];
  };

  xdg.configFile = {
    "Kvantum" = {
      source = ./configs/Kvantum;
      recursive = true;
    };
    "qt5ct/qt5ct.conf".text = ''
      [Appearance]
      custom_palette=false
      icon_theme=Tela
      standard_dialogs=default
      style=kvantum
    '';
  };

  # [Colors:View] BackgroundAlternate overridden for dolphin
  xdg.dataFile = {
    "color-schemes/Layan.colors".source = ./configs/color-schemes/Layan.colors;
    "color-schemes/LayanLight.colors".source = ./configs/color-schemes/LayanLight.colors;
  };

  wayland.windowManager.hyprland.settings = {
    env = [
      "XCURSOR_THEME, breeze_cursors"
      "XCURSOR_SIZE, 24"
      "QT_STYLE_OVERRIDE, kvantum" # *) set QT_STYLE_OVERRIDE for hyprland only
    ];
  };
}
