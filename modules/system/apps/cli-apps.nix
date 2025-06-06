{ pkgs, ... }:

{
  # Collection of useful CLI apps
  environment.systemPackages = with pkgs; [
    acpi
    bat
    btop
    curl
    delta
    efibootmgr
    eza
    fastfetch
    ffmpeg
    fzf
    gnugrep
    gnused
    htop
    imagemagick
    killall
    libnotify
    pandoc
    pciutils
    ripgrep
    rsync
    tldr
    tmux
    sops
    unzip
    usbutils
    wget
  ];

  programs.dconf.enable = true;
}
