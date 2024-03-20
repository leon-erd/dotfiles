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
    platformTheme = "qtct";
    style.name = "kvantum";
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
    exec-once = [
      "hyprctl setcursor breeze_cursors 24"
    ];
  };
}
