{
  lib,
  pkgs,
  myPkgs,
  ...
}:

let
  allConfig = {
    # set some important things
    nixpkgs.pkgs = myPkgs;
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    nix.channel.enable = false;
    nix.optimise.automatic = true; # optimise nix store disk space by hard linking identical files

    # set zsh as default shell
    programs.zsh.enable = true;
    environment.pathsToLink = [ "/share/zsh" ]; # needed for completion for system packages

    # install home-manager
    environment.systemPackages = with pkgs; [
      home-manager
    ];
  };

  linuxConfig = {
    hardware.enableAllFirmware = true;
    users.defaultUserShell = pkgs.zsh;
  };
in
lib.mkMerge [
  allConfig
  (lib.optionalAttrs myPkgs.stdenv.isLinux linuxConfig)
]
