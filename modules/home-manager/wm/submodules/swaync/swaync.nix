{ pkgs, ... }:

{
  home.packages = [
    (pkgs.swaynotificationcenter.overrideAttrs (previousAttrs:  rec {
      version = "0.10.0";
      src = pkgs.fetchFromGitHub {
        owner = "ErikReider";
        repo = previousAttrs.pname;
        rev = "v${version}";
        hash = "sha256-7O+DX4uuncUqx5zEKQprZE6tctteT6NU01V2EBHiFqA=";
      };
      patches = [];
      postPatch = ''
        chmod +x build-aux/meson/postinstall.py
        patchShebangs build-aux/meson/postinstall.py
      '';
      nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [
        pkgs.sassc
      ];
      buildInputs = previousAttrs.buildInputs ++ [
        pkgs.gvfs
        pkgs.pantheon.granite
      ];
    }))
  ];

  wayland.windowManager.hyprland.settings = {
    bind = [ "$mainMod, N, exec, swaync-client -t -sw" ];
    exec-once = [ "swaync" ];
    layerrule = [
      "blur, swaync-control-center"
      "blur, swaync-notification-window"
      "ignorezero, swaync-control-center"
      "ignorezero, swaync-notification-window"
    ];
  };

  xdg.configFile."swaync" = {
    source = ./configs;
    recursive = true;
  };
}
