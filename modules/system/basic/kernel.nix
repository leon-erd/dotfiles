{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest; # get latest stable kernel
}
