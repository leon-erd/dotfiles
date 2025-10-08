{
  pkgs,
  lib,
  userSettings,
  ...
}:

let

  allConfig = {
    home.packages = with pkgs; [
      bitwarden-desktop
      meld
    ];
  };

  linuxConfig = {
    services.nextcloud-client = {
      enable = true;
      startInBackground = true;
    };

    programs.distrobox = {
      enable = true;
      containers = { };
    };
  };

in
{
  imports = [
    ./submodules/firefox.nix
  ];
}
// lib.mkMerge [
  allConfig
  (lib.optionalAttrs userSettings.isLinux linuxConfig)
]
