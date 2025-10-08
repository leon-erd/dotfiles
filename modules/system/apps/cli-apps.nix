{
  pkgs,
  lib,
  myPkgs,
  ...
}:

let
  allConfig = {
    # Collection of useful CLI apps
    environment.systemPackages = with pkgs; [
      bat
      btop
      curl
      delta
      eza
      fastfetch
      ffmpeg
      file
      fzf
      gnugrep
      gnused
      htop
      imagemagick
      jq
      killall
      libnotify
      nano
      pandoc
      pciutils
      ripgrep
      rsync
      tldr
      sops
      unzip
      usbutils
      wget
    ];

    programs.tmux = {
      enable = true;
      extraConfig = ''
        set -g mouse on
      '';
    };
  };

  linuxConfig = {
    environment.systemPackages = with pkgs; [
      acpi
      efibootmgr
    ];
  };
in

lib.mkMerge [
  allConfig
  (lib.optionalAttrs myPkgs.stdenv.isLinux linuxConfig)
]
