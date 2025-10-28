{ ... }:

{
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  security.pam.services.sudo_local.touchIdAuth = true;

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

  # Manual configurations
  # setup Scroll Reverser and MiddleClick
  # Desktop & Dock -> Desktop & Stage Manager -> Click wallpaper to reveal desktop - Only in Stage Manager
  # defaults write -g NSWindowShouldDragOnGesture -bool true # Now, you can move windows by holding ctrl + cmd and dragging any part of the window (not necessarily the window title)
}
