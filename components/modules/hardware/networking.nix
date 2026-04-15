{ ... }:

{
  flake.modules.nixos.networking =
    { pkgs, config, ... }:

    {
      # Enable networking
      networking.hostName = config.mySystemConfig.hostname; # Define your hostname.
      networking.networkmanager.enable = true;
      environment.systemPackages = [ pkgs.networkmanagerapplet ];
      # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

      services.resolved.enable = true; # needed for wireguard
    };
}
