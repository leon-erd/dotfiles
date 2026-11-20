{ self, ... }:
let
  settings = import ./_settings-base.nix;
  networkIpv4 = "10.10.10";
  networkIpv6 = "fd10:10:10";
in
{
  flake.modules.nixos.hostRaspberrypiSystemConfig =
    { config, ... }:
    {
      imports = with self.modules.generic; [
        configSystemOptions
        hostRaspberrypiUserConfig
      ];

      mySystemConfig = {
        hostname = settings.hostname;
        domain = "amysweinhaus.ddnss.de";
        localIpv4 = "${networkIpv4}.10";
        localNetworkIpv4 = "${networkIpv4}.0/24";
        localIpv6 = "${networkIpv6}::10";
        localNetworkIpv6 = "${networkIpv6}::/64";
        externalInterface = "enu1u1u1";
        acmeEmail = "leonvincenterd@web.de";
        nextcloud = {
          drives = {
            main = "usb-TOSHIBA_External_USB_3.0_20200714006512F-0:0-part1";
            backup = "usb-Intenso_External_USB_3.0_20161230160B8-0:0-part1";
          };
          trustedDomains = [ config.mySystemConfig.localIpv4 ];
        };
        pihole.hosts = [
          "${config.mySystemConfig.localIpv4} raspberry.pi"
          "${config.mySystemConfig.localIpv6} raspberry.pi"
          "${networkIpv4}.1 fritz.box"
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
