{ pkgs, ... }:

# https://wiki.nixos.org/wiki/Accelerated_Video_Playback
{
  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)

      # OpenCL support (needed for hashcat)
      intel-ocl
      intel-compute-runtime
      pocl
      ocl-icd
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  }; # Force intel-media-driver
}
