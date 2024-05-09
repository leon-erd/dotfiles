{ pkgs, ... }:

{
  # Collection of useful CLI apps
  environment.systemPackages = with pkgs; [
    acpi
    bat
    btop
    curl
    efibootmgr
    eza
    fastfetch
    ffmpeg
    fzf
    gnugrep
    gnused
    htop
    killall
    libnotify
    pandoc
    pciutils
    ripgrep
    rsync
    tldr
    tmux
    unzip
    usbutils
    wget
  ];

  programs.dconf.enable = true;
}
