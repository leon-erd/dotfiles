{ pkgs, ... }:

{
  # Enable CUPS to print documents + avahi for scanner detection
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  environment.systemPackages = with pkgs; [
    cups-filters
    system-config-printer
  ];
}
