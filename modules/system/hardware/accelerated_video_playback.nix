{ pkgs, ... }:

# https://wiki.nixos.org/wiki/Accelerated_Video_Playback
{
  hardware.opengl = {
    extraPackages = with pkgs; [
      libvdpau-va-gl
    ];
  };
}
