{ ... }:
{
  flake.modules.nixos.hostZollsoftMacSystemExtra =
    { self, inputs, pkgs, ... }:
    {
      imports = [
        inputs.nix-homebrew.darwinModules.nix-homebrew
      ];

      nix-homebrew = {
        enable = true;
        enableRosetta = true; # for Apple Silicon
        user = "leon.erd";
        mutableTaps = true;
        autoMigrate = true;
      };

      homebrew = {
        enable = true;
        brews = [
          "rbenv" # better as brew than nix package because brew package has all dependencies included that we need for "gem install"
          "gettext"
          "ktlint"
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
          "postman"
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

      system.primaryUser = "leon.erd";

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      system.stateVersion = 6;
    };

  flake.modules.homeManager.hostZollsoftMacHmExtra =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      imports = [ ./_hm-copy-apps.nix ];

      home.username = config.myUserConfig.username;
      home.homeDirectory = "/Users/${config.myUserConfig.username}";
      xdg.enable = true;
      programs.home-manager.enable = true;

      programs.firefox.profiles.${config.myUserConfig.username} = {
        settings = lib.mkForce {
          "browser.toolbars.bookmarks.visibility" = "never";
        };
        bookmarks = lib.mkForce { };
      };

      programs.zsh.initContent = ''
        export PATH="/opt/homebrew/bin:$PATH"
        export PATH="$PATH:/usr/local/bin"
        export PATH="$PATH:$HOME/.pub-cache/bin"
        ## [Completion]
        ## Completion scripts setup. Remove the following line to uninstall
        [[ -f /Users/leon.erd/.dart-cli-completion/zsh-config.zsh ]] && . /Users/leon.erd/.dart-cli-completion/zsh-config.zsh || true
        ## [/Completion]
        eval "$(rbenv init - zsh)"
        export LANG=en_US.UTF-8
      '';

      home.packages = with pkgs; [
        appcleaner
        autoraise
        betterdisplay
        slack
        spotify
        telegram-desktop
      ];

      home.stateVersion = "25.05"; # Do not modify
    };
}