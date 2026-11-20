{ ... }:

{
  flake.modules.homeManager.xournalpp =
    {
      pkgs,
      lib,
      config,
      ...
    }:

    let
      # nixpkgs only provides the binary on macOS. The app bundle makes Xournal++
      # available in Launchpad/Spotlight and in Finder's "Open With" menu.
      infoPlist = lib.generators.toPlist { escape = true; } {
        # App metadata for Spotlight
        CFBundleName = "Xournal++";
        CFBundlePackageType = "APPL";
        CFBundleIdentifier = "com.github.xournalpp";
        CFBundleExecutable = "xournalpp";
        CFBundleIconFile = "xournalpp.icns";
        NSHighResolutionCapable = true;
        CFBundleDocumentTypes = [
          {
            CFBundleTypeRole = "Editor";
            CFBundleTypeExtensions = [
              "xopp"
              "xopt"
              "xoj"
            ];
          }
          {
            # Offer Xournal++ for annotating PDFs without becoming the default PDF app
            CFBundleTypeRole = "Editor";
            LSItemContentTypes = [ "com.adobe.pdf" ];
            LSHandlerRank = "Alternate";
          }
        ];
      };

      xournalppApp = pkgs.runCommand "xournalpp-app" { } ''
        app=$out/Applications/Xournal++.app/Contents
        mkdir -p $app/MacOS $app/Resources
        cp ${pkgs.writeText "Info.plist" infoPlist} $app/Info.plist
        ln -s ${lib.getExe pkgs.xournalpp} $app/MacOS/xournalpp
        cp ${pkgs.xournalpp.src}/mac-setup/icon/xournalpp.icns $app/Resources/
      '';
    in
    {
      home.packages = [
        pkgs.xournalpp
      ]
      ++ lib.optional pkgs.stdenv.hostPlatform.isDarwin xournalppApp;

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
