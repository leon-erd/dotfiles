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
