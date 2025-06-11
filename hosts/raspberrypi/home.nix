{ inputs, ... }:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ../../modules/home-manager/basic.nix
    ../../modules/home-manager/devel/git.nix
    ../../modules/home-manager/devel/shell.nix
    # ../../modules/home-manager/devel/python.nix
  ];

  home.stateVersion = "24.11"; # Do not modify
}
