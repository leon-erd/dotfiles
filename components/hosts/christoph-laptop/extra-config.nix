{ ... }:
{
  flake.modules.nixos.hostChristophLaptopSystemExtra =
    { ... }:
    {
      system.stateVersion = "23.11"; # Do not modify
    };

  flake.modules.homeManager.hostChristophLaptopHmExtra =
    { lib, config, ... }:
    let
      # plasma-manager has no option for the display scale
      setScale = "kscreen-doctor output.eDP-1.scale.1.25";
    in
    {
      programs.firefox.profiles.${config.myUserConfig.username} = {
        search = lib.mkForce {
          default = "ecosia";
          force = true;
        };
      };

      # applied on every login ...
      programs.plasma.startup.startupScript.display-scale = {
        text = setScale;
        runAlways = true;
      };
      # ... and when activating from inside a plasma session (a failure must not abort the activation)
      home.activation.displayScale = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if [ "''${XDG_CURRENT_DESKTOP:-}" = KDE ]; then
          run ${setScale} || echo "${setScale} failed, the scale is applied on the next login"
        fi
      '';

      home.stateVersion = "23.11"; # Do not modify
    };
}
