{ ... }:

{
  # Configuration for KDE Dolphin and Okular on macOS. Both are not available in nixpkgs for
  # macOS and are installed manually (see README.md).
  # On macOS, KDE apps read their config from ~/Library/Preferences and their data
  # (color schemes, icon themes, service menus) from ~/Library/Application Support.
  flake.modules.homeManager.kdeAppsMacos =
    {
      pkgs,
      lib,
      config,
      ...
    }:

    let
      appSupport = "Library/Application Support";

      # breeze-icons (Tela's fallback theme) is Linux-only in nixpkgs; Dolphin bundles Breeze itself
      telaIconTheme = pkgs.tela-icon-theme.overrideAttrs (old: {
        propagatedBuildInputs = [ ];
        meta = old.meta // {
          platforms = lib.platforms.darwin;
        };
      });

      # Compresses the selected files/folders (all from one directory) into a zip next to them
      compressZip = pkgs.writeShellScript "compress-zip" ''
        cd "$(dirname "$1")" || exit 1
        if [ $# -eq 1 ]; then name="$(basename "$1")"; else name="Archiv"; fi
        out="$name.zip"
        i=2
        while [ -e "$out" ]; do out="$name $i.zip"; i=$((i + 1)); done
        ${lib.getExe pkgs.zip} -r -y -q -X "$out" "''${@##*/}" -x "*.DS_Store"
      '';
    in
    {
      home.file = {
        "${appSupport}/color-schemes/Layan.colors".source =
          ../../desktop/theming/configs/color-schemes/Layan.colors;
        "${appSupport}/icons/Tela".source = "${telaIconTheme}/share/icons/Tela";
        "${appSupport}/kio/servicemenus/compress-zip.desktop" = {
          executable = true; # KIO only loads service menus from user directories if they are executable
          text = ''
            [Desktop Entry]
            Type=Service
            MimeType=application/octet-stream;inode/directory;
            Actions=compressZip;

            [Desktop Action compressZip]
            Name=Als ZIP komprimieren
            Icon=archive-insert
            Exec=${compressZip} %F
          '';
        };
      };

      # Writable links to the rc files shared with the Linux hosts (see qtApps)
      home.activation.myKdeRcFiles =
        let
          targetDirectory = "${config.myUserConfig.flakeDirectory}/components/modules/apps/config_files";
        in
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          run ln -sf ${targetDirectory}/dolphinrc "$HOME/Library/Preferences/dolphinrc"
          run ln -sf ${targetDirectory}/okularrc "$HOME/Library/Preferences/okularrc"
        '';
    };
}
