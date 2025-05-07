{ pkgs, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in

{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  home.packages = with pkgs; [
    eog
    mpv
    qpwgraph
#     spotify
    vlc
  ];

  programs.spicetify = {
    enable = true;

    # Dribbblish
    theme = spicePkgs.themes.dribbblish;
    colorScheme = "rosepine";

    # Comfy
#     theme = spicePkgs.themes.comfy;
#     colorScheme = "catppuccin-mocha";

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      keyboardShortcut
      loopyLoop
      shuffle
    ];
    enabledCustomApps = with spicePkgs.apps; [
      lyricsPlus
    ];
  };
}
