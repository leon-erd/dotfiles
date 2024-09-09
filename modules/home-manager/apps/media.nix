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
#     theme = spicePkgs.themes.dribbblish;
#     colorScheme = "rosepine";
    # This commit broke the Dribblish theme for spotify
    # https://github.com/NixOS/nixpkgs/pull/321319
#     spotifyPackage = pkgs.spotify.overrideAttrs rec {
#       version = "1.2.31.1205.g4d59ad7c";
#       rev = "75";
#       src = pkgs.fetchurl {
#         name = "spotify-${version}-${rev}.snap";
#         url = "https://api.snapcraft.io/api/v1/snaps/download/pOBIoZ2LrCB3rDohMxoYGnbN14EHOgD7_${rev}.snap";
#         hash = "sha512-o4iLcbNqbsxo9YJMy0SXO7Udv4CMhhBcsf53UuqWKFFWY/jKVN+Lb+dB7Jf9+UowpmbrP44w97Oi+dnbfFXYjQ==";
#       };
#       unpackPhase = ''
#         runHook preUnpack
#         unsquashfs "$src" '/usr/share/spotify' '/usr/bin/spotify' '/meta/snap.yaml'
#         cd squashfs-root
#         if ! grep -q 'grade: stable' meta/snap.yaml; then
#           # Unfortunately this check is not reliable: At the moment (2018-07-26) the
#           # latest version in the "edge" channel is also marked as stable.
#           echo "The snap package is marked as unstable:"
#           grep 'grade: ' meta/snap.yaml
#           echo "You probably chose the wrong revision."
#           exit 1
#         fi
#         if ! grep -q '${version}' meta/snap.yaml; then
#           echo "Package version differs from version found in snap metadata:"
#           grep 'version: ' meta/snap.yaml
#           echo "While the nix package specifies: ${version}."
#           echo "You probably chose the wrong revision or forgot to update the nix version."
#           exit 1
#         fi
#         runHook postUnpack
#       '';
#     };

    # Comfy
    theme = spicePkgs.themes.comfy;
    colorScheme = "catppuccin-mocha";

    # Bloom
#     theme = {
#       src = pkgs.fetchgit {
#         url = "https://github.com/nimsandu/spicetify-bloom";
#         rev = "89e983e231f4b5ba8548ffb4a148a80a4d52aca2";
#         sha256 = "sha256-V8xt9wUg0tlJfMsxZcoD0PcVHBy6EZMvg0HKtNtpZDI=";
#       };
#       name = "src";
#       appendName = true;
#       injectCss = true;
#       replaceColors = true;
#       overwriteAssets = true;
#       sidebarConfig = true;
#     };
#     colorScheme = "comfy";
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
