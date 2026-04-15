{ self, ... }:

{
  flake.modules.homeManager.hyprlandExecOnce =
    { pkgs, ... }:

    {
      wayland.windowManager.hyprland.settings = {
        # Execute at launch
        exec-once = with self.packages.${pkgs.stdenv.hostPlatform.system}; [
          "sleep 5 && ${hibernateOnLowBattery}"
          "sleep 5 && ${restartFailedSystemdUserServices}"
        ];
      };
    };
}
