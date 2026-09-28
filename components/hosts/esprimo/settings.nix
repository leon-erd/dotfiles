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
        domain = "amysweinhaus.ddnss.de";
        localIp = "${network}.10";
        localNetwork = "${network}.0/24";
        externalInterface = "eno1";
        acmeEmail = "leonvincenterd@web.de";
        smartHome.zigbee2mqtt = {
          port = "/dev/serial/by-id/usb-SONOFF_SONOFF_Dongle_Lite_MG21_e2815abfcfa2ef1193d2976661ce3355-if00-port0";
          adapter = "ember";
          # Adjust to local 2.4 GHz Wi-Fi channels to reduce interference.
          channel = 25;
          # Keep these identifiers stable after pairing the first device.
          panId = 3594;
          extPanId = [
            59
            0
            62
            152
            80
            150
            174
            255
          ];
        };
        nextcloud = {
          drives = {
            main = "usb-TOSHIBA_External_USB_3.0_20200714006512F-0:0-part1";
            backup = "usb-Intenso_External_USB_3.0_20161230160B8-0:0-part1";
          };
          trustedDomains = [ config.mySystemConfig.localIp ];
        };
        pihole.hosts = [
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
