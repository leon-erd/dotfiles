{
  pkgs,
  lib,
  config,
  userSettings,
  ...
}:

{
  home.packages = with pkgs; [
    onlyoffice-bin
    qalculate-gtk
    xournalpp
  ];

  home.activation = {
    myXorunalppSettings =
      let
        symlinkDir = "${config.xdg.configHome}/xournalpp";
        targetDirectory = "${userSettings.flakeDirectory}/modules/home-manager/apps/config_files";
      in
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ln -sf ${targetDirectory}/xournalpp_settings.xml ${symlinkDir}/settings.xml
      '';
  };
}
