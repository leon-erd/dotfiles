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
    file
    fzf
    gnugrep
    gnused
    htop
    imagemagick
    jq
    killall
    libnotify
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
    clock24 = true;
    extraConfig = ''
      set -g mouse on
    '';
  };
}
