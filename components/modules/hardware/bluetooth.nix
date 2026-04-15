{ ... }:

{
  flake.modules.nixos.bluetooth =
    { ... }:

    {
      # Bluetooth
      hardware.bluetooth.enable = true;
      services.blueman.enable = true;
    };
}
