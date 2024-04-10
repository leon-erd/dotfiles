{ pkgs, ... }:

# https://nixos.wiki/wiki/Accelerated_Video_Playback
{
  hardware.opengl = {
    extraPackages = with pkgs; [
      libvdpau-va-gl
    ];
  };
}
