{
  description = "Leons Flake for NixOS and Home Manager configuration";

  outputs =
    { self, ... }@inputs:
    let
      inspiron-laptop = import ./hosts/inspiron-laptop/flakeConfiguration.nix inputs;
    in
    {
      # insert other configurations by merging (need to be imported in let/in)
      nixosConfigurations = inspiron-laptop; # // <someOtherHost>;
      homeConfigurations = inspiron-laptop; # // <someOtherHost>;
    };

  inputs = {
    #nixpkgsLocal.url = "git+file:///home/leon/Downloads/nixpkgs";
    #nixpkgsStable.url = "nixpkgs/nixos-24.05";
    nixpkgs.url = "nixpkgs/nixos-unstable";

    #home-managerStable = {
    #  url = "github:nix-community/home-manager/release-24.05";
    #  inputs.nixpkgs.follows = "nixpkgsStable";
    #};
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    # Do not override Hyprland’s nixpkgs input. Doing so will make the cache useless, since you’re building from a different Nixpkgs commit.
    hyprland.url = "github:hyprwm/Hyprland";

    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
