{
  lib,
  pkgs,
  userSettings,
  config,
  ...
}:

# adding this to kdeglobals enables the icons for plasma6 apps:
# [Icons]
# Theme=Tela

{
  home.packages = with pkgs; [
    kdePackages.ark
    kdePackages.filelight
    kdePackages.kate
    kdePackages.okular
    # Alternating colors in details view is fucked up. Cannot find a fix for plasma6 (previous fix of setting alt.base color in kvantum theme to transparent does not work anymore)
    libsForQt5.dolphin
    libsForQt5.kio-extras # mtp support for dolphin
    qalculate-qt
  ];

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
