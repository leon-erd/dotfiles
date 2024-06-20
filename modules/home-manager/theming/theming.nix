{ pkgs, ... }:

{
  home.packages = with pkgs; [
    libsForQt5.breeze-gtk
    libsForQt5.qtstyleplugin-kvantum
    layan-gtk-theme
  ];


  gtk = {
    enable = true;
    theme = {
      package = pkgs.layan-gtk-theme;
      name = "Layan-Dark";
    };
    cursorTheme = {
      package = pkgs.libsForQt5.breeze-gtk;
      name = "breeze_cursors";
      size = 24;
    };
    iconTheme = {
      package = pkgs.tela-icon-theme;
      name = "Tela";
    };
    font = {
      package = pkgs.nerdfonts;
      name = "NotoSansNerdFont";
      size = 11;
    };
  };


  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum"; # this sets QT_STYLE_OVERRIDE=kvantum which fucks up plasma6. Disable this line if you want to use kde
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


  wayland.windowManager.hyprland.settings = {
    env = [
      "XCURSOR_THEME, breeze_cursors"
      "XCURSOR_SIZE, 24"
    ];
  };
}
