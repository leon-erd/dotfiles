{ self, ... }:
let
  settings = import ./_settings-base.nix;
in
{
  flake.modules.nixos.hostRaspberrypiSystemConfig =
    { ... }:
    {
      imports = with self.modules.generic; [
        configSystemOptions
        hostRaspberrypiUserConfig
      ];

      mySystemConfig = {
        hostname = settings.hostname;
        localIp = "192.168.179.200";
        acmeEmail = "leonvincenterd@web.de";
        nextcloud = {
          drives = {
            main = "usb-TOSHIBA_External_USB_3.0_20200714006512F-0:0-part1";
            backup = "usb-Intenso_External_USB_3.0_20161230160B8-0:0-part1";
          };
          hostName = "amysweinhaus.ddnss.de";
          trustedDomains = [ "192.168.179.200" ];
        };
        pihole.hosts = [
          "192.168.179.200 raspberry.pi"
          "192.168.179.200 amysweinhaus.ddnss.de"
        ];
        wireguard = {
          externalInterface = "enu1u1u1";
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

  flake.modules.generic.hostRaspberrypiUserConfig =
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
          flakeDirectory = "/home/${settings.username}/dotfiles/components/hosts/raspberrypi";
          systemConfigurationName = settings.systemConfigurationName;
          userConfigurationName = settings.userConfigurationName;
        }
      ];
    };
}