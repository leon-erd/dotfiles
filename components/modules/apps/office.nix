{ ... }:

{
  flake.modules.homeManager.office =
    {
      pkgs,
      lib,
      config,
      ...
    }:

    {
      home.packages = with pkgs; [
        qalculate-gtk
        xournalpp
      ];

      programs.onlyoffice.enable = true;

      home.activation = {
        myXorunalppSettings =
          let
            symlinkDir = "${config.xdg.configHome}/xournalpp";
            targetDirectory = "${config.myUserConfig.flakeDirectory}/components/modules/apps/config_files";
          in
          lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            run ln -sf ${targetDirectory}/xournalpp_settings.xml ${symlinkDir}/settings.xml
          '';
      };
    };
}
