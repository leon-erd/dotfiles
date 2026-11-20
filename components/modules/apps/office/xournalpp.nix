{ ... }:

{
  flake.modules.homeManager.xournalpp =
    {
      pkgs,
      lib,
      config,
      ...
    }:

    {
      home.packages = with pkgs; [
        xournalpp
      ];

      home.activation = {
        myXorunalppSettings =
          let
            symlinkDir = "${config.xdg.configHome}/xournalpp";
            targetDirectory = "${config.myUserConfig.flakeDirectory}/components/modules/apps/config_files";
          in
          lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            run mkdir -p ${symlinkDir}
            run ln -sf ${targetDirectory}/xournalpp_settings.xml ${symlinkDir}/settings.xml
          '';
      };
    };
}
