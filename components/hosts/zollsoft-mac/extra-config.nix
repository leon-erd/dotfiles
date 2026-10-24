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

      # Build Linux systems locally; the VZ guest uses Rosetta for x86_64 binaries.
      nix.linux-builder = {
        enable = true;
        package = pkgs.darwin.linux-builder-vz;
        systems = [
          "aarch64-linux"
          "x86_64-linux"
        ];
        maxJobs = 12;
        config = {
          virtualisation.cores = 12;
          virtualisation.darwin-builder.memorySize = 16 * 1024; # MiB
          virtualisation.darwin-builder.diskSize = 40 * 1024; # MiB

          # The guest store is only a cache; results are copied back to the host.
          # Empty it daily instead of relying on auto-GC: that only starts when the
          # disk is almost full and then frees too little for 12 parallel jobs.
          # Auto-GC must stay a last resort, since a GC during a deploy deletes
          # inputs that in-flight remote builds found present and did not re-copy.
          nix.gc.automatic = true;

          # Reboot the guest after a kernel panic instead of hanging with all
          # vCPUs spinning at 100%.
          boot.kernelParams = [ "panic=5" ];

          # Keep guest kernel diagnostics without macOS unified-log rate limiting.
          virtualisation.vz.console = "file";
          virtualisation.vz.consoleLog = "./console.log";

          # root ("/", where Nix builds under /tmp by default) is a RAM-backed
          # tmpfs capped at ~50% of memorySize on both the QEMU and VZ builder
          # backends; large builds can exceed that.
          # Build on the much bigger persistent store disk instead.
          # Must be root-only (0755) -- Nix refuses a world-writable build-dir.
          systemd.tmpfiles.rules = [ "d /nix/.rw-store/build-tmp 0755 root root - -" ];
          nix.settings.build-dir = "/nix/.rw-store/build-tmp";
        };
      };

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
          "poppler"
        ];
        casks = [
          "android-studio"
          "chatgpt"
          "claude"
          "claude-code"
          "firefox"
          "intellij-idea"
          "karabiner-elements"
          "keka"
          "libreoffice"
          "middleclick"
          "nextcloud"
          "openvpn-connect"
          "postman"
          "scroll-reverser"
          "teamviewer"
          "telegram-desktop"
          "temurin@21"
          "temurin@25"
          "thunderbird"
          "ukelele"
          "whatsapp"
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
        gitlab-ci-local
        glab
        lulu
        nixos-rebuild
        orbstack
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

      # Firefox is installed as a brew cask: Nix's firefox and firefox-bin
      # bundles are not validly signed, so macOS denies them access to their
      # own profile in "Library/Application Support/Firefox".
      # Same applies to Thunderbird.
      programs.firefox.package = null;
      # home-manager's thunderbird module doesn't accept null.
      programs.thunderbird.package = pkgs.emptyDirectory;

      # The signed Firefox would otherwise create a dedicated per-install profile,
      # which it can't register in the read-only profiles.ini linked by home-manager.
      # The LegacyProfiles policy has no effect on macOS.
      launchd.agents.firefox-legacy-profiles = {
        enable = true;
        config = {
          ProgramArguments = [
            "/bin/launchctl"
            "setenv"
            "MOZ_LEGACY_PROFILES"
            "1"
          ];
          RunAtLoad = true;
        };
      };

      programs.firefox.profiles.${config.myUserConfig.username} = {
        settings = lib.mkForce {
          "browser.toolbars.bookmarks.visibility" = "never";
        };
      };

      home.sessionVariables = {
        DEPLOY_FLAKE = "${config.myUserConfig.flakeDirectory}/components/hosts/esprimo";
        DEPLOY_USER = "leon";
        DEPLOY_HOST = "esprimo.home.arpa";
        DEPLOY_USER_CONFIG_NAME = "leon@esprimo";
        DEPLOY_SYSTEM_CONFIG_NAME = "esprimo";
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

        # OrbStack: command-line tools and integration
        source ~/.orbstack/shell/init.zsh 2>/dev/null || :
      '';

      home.packages = with pkgs; [
        appcleaner
        autoraise
        betterdisplay
        slack
        spotify

        self.packages.${pkgs.stdenv.hostPlatform.system}.remoteDeploymentSystem
        self.packages.${pkgs.stdenv.hostPlatform.system}.remoteDeploymentHome
      ];

      home.stateVersion = "25.05"; # Do not modify
    };
}
