{ ... }:

{
  flake.modules.system.cliApps =
    { pkgs, ... }:
    {
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
        nh
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

  flake.modules.nixos.cliApps =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        acpi
        efibootmgr
      ];
    };
}
