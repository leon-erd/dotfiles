{
  config,
  lib,
  pkgs,
  ...
}:

let
  appsSrc = "$newGenPath/home-path/Applications";
  baseDir = "${config.home.homeDirectory}/Applications/Home Manager Apps";

  copyScript = ''
    echo "Setting up ${baseDir}..." >&2
    appsSrc="${appsSrc}"
    if [ -d "$appsSrc" ]; then
      baseDir="${baseDir}"
      rsyncFlags=(
        --archive
        --checksum
        --copy-unsafe-links
        --delete
        --chmod=-w
        --no-group
        --no-owner
      )
      $DRY_RUN_CMD mkdir -p "$baseDir"
      $DRY_RUN_CMD ${lib.getExe pkgs.rsync} \
        ''${VERBOSE_ARG:+-v} "''${rsyncFlags[@]}" "$appsSrc/" "$baseDir"
    fi
  '';
in
{
  disabledModules = [ "targets/darwin/linkapps.nix" ];

  config = lib.mkIf pkgs.stdenv.isDarwin {
    home.activation.copyApplications = lib.hm.dag.entryAfter [ "writeBoundary" ] copyScript;
  };
}
