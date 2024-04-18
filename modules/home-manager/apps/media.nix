{ pkgs, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in

{
  imports = [ inputs.spicetify-nix.homeManagerModule ];

  home.packages = with pkgs; [
    gnome.eog
    mpv
    qpwgraph
#     spotify
    vlc
  ];

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.Dribbblish;
    colorScheme = "rosepine";
    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      keyboardShortcut
      loopyLoop
      shuffle
    ];
    enabledCustomApps = with spicePkgs.apps; [
      lyrics-plus
    ];
  };
}
