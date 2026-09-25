{ self, ... }:
let
  settings = import ./_settings-base.nix;
  network = "10.10.10";
in
{
  flake.modules.nixos.hostEsprimoSystemConfig =
    { config, ... }:
    {
      imports = with self.modules.generic; [
        configSystemOptions
        hostEsprimoUserConfig
      ];

      mySystemConfig = {
        hostname = settings.hostname;
        localIp = "${network}.10";
        localNetwork = "${network}.0/24";
        externalInterface = "eno1";
        acmeEmail = "leonvincenterd@web.de";
        nextcloud = {
          drives = {
            main = "usb-TOSHIBA_External_USB_3.0_20200714006512F-0:0-part1";
            backup = "usb-Intenso_External_USB_3.0_20161230160B8-0:0-part1";
          };
          hostName = "amysweinhaus.ddnss.de";
          trustedDomains = [ config.mySystemConfig.localIp ];
        };
        pihole.hosts = [
          "${config.mySystemConfig.localIp} amysweinhaus.ddnss.de"
          "${config.mySystemConfig.localIp} ${config.mySystemConfig.hostname}.home.arpa"
          "${network}.1 fritz.box"
        ];
        wireguard = {
          clientPeers = [
            {
              name = "inspiron-laptop";
              publicKey = "dLHb13EIwUM1HJoEPojOskp18c87Ciu/ZYUZmIkQMBA=";
              allowedIPs = [ "10.100.0.2/32" ];
            }
            {
              name = "leon-handy";
              publicKey = "ahgGz2HSN6L0SaA85tEUccSogdu/6XCOJKsS0XyI238=";
              allowedIPs = [ "10.100.0.3/32" ];
            }
          ];
        };
      };
    };

  flake.modules.generic.hostEsprimoUserConfig =
    { ... }:
    {
      imports = with self.modules.generic; [
        configUserOptions
      ];

      myUsers = [
        {
          username = settings.username;
          name = "Leon";
          email = "leonvincenterd@web.de";
          flakeDirectory = "/home/${settings.username}/dotfiles/components/hosts/esprimo";
          systemConfigurationName = settings.systemConfigurationName;
          userConfigurationName = settings.userConfigurationName;
        }
      ];
    };
}
