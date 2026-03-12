# karabiner-elements needs to be installed via brew because it needs to be in /Applications for the permissions to work
{
  lib,
  userSettings,
  ...
}:

{
  home.activation = {
    myKarabinerConfig =
      let
        karabinerPath = "$XDG_CONFIG_HOME/karabiner";
        targetDir = "${userSettings.flakeDirectory}/modules/home-manager/wm/useful_utilities/karabiner/karabiner";
      in
      # Somehow karabiner-elements creates a new symlink in its folder so we want to remove it here
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ln -sf ${targetDir} ${karabinerPath}
        run rm -f ${karabinerPath}/karabiner
      '';
  };
}
