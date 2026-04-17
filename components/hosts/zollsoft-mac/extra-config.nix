{ self, ... }:
{
  flake.modules.darwin.hostZollsoftMacSystemExtra =
    {
      inputs,
      pkgs,
      config,
      ...
    }:
    let
      username = (builtins.head config.myUsers).username;
    in
    {
      imports = [
        inputs.nix-homebrew.darwinModules.nix-homebrew
      ];

      nix-homebrew = {
        enable = true;
        enableRosetta = true; # for Apple Silicon
        user = username;
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

      # development tools
      environment.systemPackages = with pkgs; [
        acli
        docker-compose
        docker-credential-helpers
        fvm
        glab
        pgcli
        podman
      ];

      fonts.packages = with pkgs.nerd-fonts; [
        hack
        jetbrains-mono
      ];

      system.primaryUser = username;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
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
        [[ -f /Users/${config.myUserConfig.username}/.dart-cli-completion/zsh-config.zsh ]] && . /Users/${config.myUserConfig.username}/.dart-cli-completion/zsh-config.zsh || true
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
