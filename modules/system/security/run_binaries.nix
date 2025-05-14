# https://unix.stackexchange.com/questions/522822/different-methods-to-run-a-non-nixos-executable-on-nixos
# https://github.com/thiagokokada/nix-alien
{ pkgs, options, ... }:

{
  programs.nix-ld = {
    enable = true;
    libraries = options.programs.nix-ld.libraries.default
    ++ (with pkgs; [
      # Add any missing dynamic libraries for unpackaged programs here, NOT in environment.systemPackages
    ]);
  };
}
