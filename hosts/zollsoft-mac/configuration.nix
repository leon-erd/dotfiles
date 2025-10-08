{ inputs, pkgs, ... }:

{
  imports = [
    ../../modules/system/basic/settings.nix
    ../../modules/system/apps/cli-apps.nix
    # ../../modules/system/apps/virtualisation.nix
    # ../../modules/system/fonts/fonts.nix
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  fonts.packages = [ pkgs.nerd-fonts.hack ];

  environment.systemPackages = [ pkgs.nh ];

  system.primaryUser = "leon.erd";
  system.defaults = {
    dock = {
      tilesize = 30;
      static-only = true;
      orientation = "left";
    };
    finder = {
      ShowPathbar = true;
      ShowStatusBar = true;
      NewWindowTarget = "Home";
      FXPreferredViewStyle = "clmv";
      AppleShowAllExtensions = true;
    };
    trackpad = {
      Dragging = true;
      Clicking = true;
      TrackpadRightClick = true;
    };
  };
}
