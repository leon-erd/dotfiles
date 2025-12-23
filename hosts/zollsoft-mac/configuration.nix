{ pkgs, inputs, ... }:

let
  primaryUser = "leon.erd";
in
{
  imports = [
    ../../modules/system/apps/cli-apps.nix
    ../../modules/system/basic/settings.nix
    ../../modules/system/basic/macos-settings.nix
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nix-homebrew = {
    enable = true;
    enableRosetta = true; # for Apple Silicon
    user = primaryUser;
    # declarative tap management
    taps = { };
    mutableTaps = true; # with mutableTaps disabled, taps can no longer be added imperatively with `brew tap`
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    brews = [
      "rbenv" # better as brew than nix package because brew package has all dependencies included that we need for "gem install"
      "gettext"
    ];
    casks = [
      "claude-code"
      "gather"
      "jetbrains-toolbox"
      "karabiner-elements"
      "keka"
      "libreoffice"
      "middleclick"
      "nextcloud"
      "openvpn-connect"
      "scroll-reverser"
      "teamviewer"
      "ukelele"
    ];
    onActivation = {
      cleanup = "zap";
      upgrade = true;
      autoUpdate = true;
    };
  };

  # development tools
  environment.systemPackages = with pkgs; [
    docker-compose
    docker-credential-helpers
    fvm
    glab
    podman
  ];

  fonts.packages = with pkgs.nerd-fonts; [
    hack
    jetbrains-mono
  ];

  system.primaryUser = primaryUser;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}
