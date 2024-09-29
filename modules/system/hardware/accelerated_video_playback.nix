{ pkgs, ... }:

# https://wiki.nixos.org/wiki/Accelerated_Video_Playback
{
  hardware.graphics = {
    extraPackages = with pkgs; [
      libvdpau-va-gl
    ];
  };
}
