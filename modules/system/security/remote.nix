{ pkgs, ... }:

{
  services.teamviewer = {
    enable = true;
    package = pkgs.teamviewer.overrideAttrs {
      src = pkgs.fetchurl {
        url = "https://dl.teamviewer.com/download/linux/version_15x/teamviewer_15.61.3_amd64.deb";
        hash = "sha256-o7Em+QRW4TebRTJS5xjcx1M6KPh1ziB1j0fvlO+RYa4=";
      };
    };
  };
}
