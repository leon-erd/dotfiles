{ lib, pkgs, userSettings, ... }:

{
  home.packages = with pkgs; [
    dolphin
    libsForQt5.kate
    libsForQt5.okular
    libsForQt5.ark
    libsForQt5.filelight
    qalculate-qt
  ];

  home.activation = {
    myQtRcFiles =
    let
      rcPath = "~/.config";
      targetDirectory = "${userSettings.flakeDirectory}/modules/home-manager/apps/rc_files";
    in
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ln -sf ${targetDirectory}/dolphinrc ${rcPath}/dolphinrc
      run ln -sf ${targetDirectory}/katerc ${rcPath}/katerc
      run ln -sf ${targetDirectory}/kwriterc ${rcPath}/kwriterc
      run ln -sf ${targetDirectory}/okularrc ${rcPath}/okularrc
    '';
  };
}
