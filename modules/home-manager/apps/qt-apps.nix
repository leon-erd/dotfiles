{
  lib,
  pkgs,
  userSettings,
  config,
  ...
}:

# you can also set the following in ~/.config/kdeglobals instead of the individual rc files:
# [UiSettings]
# ColorScheme=LayanDark

# [Icons]
# Theme=Tela

{
  home.packages = with pkgs; [
    kdePackages.ark
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.kio-extras # mtp support for dolphin
    kdePackages.filelight
    kdePackages.kate
    kdePackages.okular
    qalculate-qt
  ];

  # https://github.com/NixOS/nixpkgs/issues/409986
  # https://discourse.nixos.org/t/dolphin-does-not-have-mime-associations/48985/7
  # if not working, try clearing cache
  xdg.configFile."menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  home.activation = {
    myQtRcFiles =
      let
        symlinkDir = config.xdg.configHome;
        targetDirectory = "${userSettings.flakeDirectory}/modules/home-manager/apps/config_files";
      in
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ln -sf ${targetDirectory}/dolphinrc ${symlinkDir}/dolphinrc
        run ln -sf ${targetDirectory}/katerc ${symlinkDir}/katerc
        run ln -sf ${targetDirectory}/kwriterc ${symlinkDir}/kwriterc
        run ln -sf ${targetDirectory}/okularrc ${symlinkDir}/okularrc
      '';
  };
}
