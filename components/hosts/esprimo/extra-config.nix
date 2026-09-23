{ ... }:
{
  flake.modules.nixos.hostEsprimoSystemExtra =
    { config, ... }:
    let
      username = (builtins.head config.myUsers).username;
    in
    {
      # SSH access for remote deployment from leon@inspiron-laptop
      users.users.${username} = {
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM22vgwjJ9HTFLvJTyQcyq4sgEFzI6jAS2FX6aB7AXVK leon@inspiron-laptop"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKNQj1Y70rPJey192A0YT2IL8gqKvYYBwDuAztsztpdH leon@zollsoft-mac"
        ];
      };
      nix.settings.trusted-users = [ username ];

      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "no";
          AllowUsers = [ username ];
          PasswordAuthentication = false;
        };
      };

      # Networking configuration
      networking.hostName = config.mySystemConfig.hostname;
      networking.wireless.enable = false;

      # Request the preferred IP via DHCP; the router supplies gateway and DNS.
      # The DHCP server may assign a different address unless it is reserved.
      networking.interfaces.${config.mySystemConfig.externalInterface}.useDHCP = true;
      networking.dhcpcd.extraConfig = ''
        interface ${config.mySystemConfig.externalInterface}
        request ${config.mySystemConfig.localIp}
      '';

      system.stateVersion = "24.11"; # Do not modify
    };

  flake.modules.homeManager.hostEsprimoHmExtra =
    { ... }:
    {
      home.stateVersion = "24.11"; # Do not modify
    };
}
