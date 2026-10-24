{ self, ... }:
{
  flake.modules.nixos.hostInspironLaptopSystemExtra =
    { ... }:
    {
      # for compiling through emulated system for raspberrypi
      boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
      system.stateVersion = "23.11"; # Do not modify
    };

  flake.modules.homeManager.hostInspironLaptopHmExtra =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      programs.firefox.profiles.${config.myUserConfig.username}.bookmarks = {
        force = true;
        settings = [
          {
            toolbar = true;
            bookmarks = [
              {
                name = "Fast.com";
                url = "https://fast.com";
              }
              {
                name = "Amy's Weinhaus";
                url = "https://cloud.amysweinhaus.ddnss.de";
              }
              {
                name = "Pihole";
                url = "https://dns.amysweinhaus.ddnss.de/admin/";
              }
              {
                name = "Github";
                url = "https://github.com/";
              }
              {
                name = "Twitch";
                url = "https://twitch.tv/directory/following";
              }
              {
                name = "Youtube";
                url = "https://youtube.com";
              }
              {
                name = "ChatGPT";
                url = "https://chat.openai.com";
              }
              {
                name = "Noogle";
                url = "https://noogle.dev/";
              }
            ];
          }
        ];
      };

      home.sessionVariables = {
        DEPLOY_FLAKE = "${config.myUserConfig.flakeDirectory}/components/hosts/raspberrypi";
        DEPLOY_USER = "leon";
        DEPLOY_HOST = "raspberry.pi";
        DEPLOY_USER_CONFIG_NAME = "leon@raspberrypi";
        DEPLOY_SYSTEM_CONFIG_NAME = "raspberrypi";
      };

      home.packages = with pkgs; [
        self.packages.${pkgs.stdenv.hostPlatform.system}.remoteDeploymentSystem
        self.packages.${pkgs.stdenv.hostPlatform.system}.remoteDeploymentHome
        claude-code
      ];

      home.activation = {
        myScripts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          run ln -Tsf ${config.myUserConfig.flakeDirectory}/components/scripts ~/scripts
        '';
      };

      home.stateVersion = "23.11";
    };
}
