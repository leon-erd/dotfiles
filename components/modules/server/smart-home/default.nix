{ self, ... }:

{
  flake.modules.nixos.smartHome =
    {
      config,
      options,
      ...
    }:
    let
      haPort = 8123;
      z2mPort = 8081;
      mosquittoPort = 1883;
    in
    {
      imports = [ self.modules.nixos.reverseProxy ];

      services.nginx.virtualHosts = {
        "ha.${config.mySystemConfig.domain}".locations."/" = {
          proxyPass = "http://127.0.0.1:${toString haPort}";
          proxyWebsockets = true;
        };
        "z2m.${config.mySystemConfig.domain}".locations."/" = {
          proxyPass = "http://127.0.0.1:${toString z2mPort}";
          proxyWebsockets = true;
        };
      };

      services.home-assistant = {
        enable = true;
        extraComponents = options.services.home-assistant.extraComponents.default ++ [
          "mqtt"
        ];
      };

      services.mosquitto = {
        enable = true;
        listeners = [
          {
            address = "127.0.0.1";
            port = mosquittoPort;
            users = {
              homeassistant = {
                passwordFile = config.sops.secrets."smart-home/mqtt_userpass/home-assistant".path;
                acl = [ "readwrite #" ];
              };
              zigbee2mqtt = {
                passwordFile = config.sops.secrets."smart-home/mqtt_userpass/zigbee2mqtt".path;
                acl = [ "readwrite #" ];
              };
            };
          }
        ];
      };

      services.zigbee2mqtt = {
        enable = true;
        settings = {
          version = 5;
          serial = {
            inherit (config.mySystemConfig.smartHome.zigbee2mqtt) port adapter;
          };
          mqtt = {
            server = "mqtt://127.0.0.1:${toString mosquittoPort}";
            user = "zigbee2mqtt";
            password = "!${config.sops.templates."zigbee2mqtt.yaml".path} mqtt_password";
          };
          frontend = {
            enabled = true;
            host = "127.0.0.1";
            port = z2mPort;
            auth_token = "!${config.sops.templates."zigbee2mqtt.yaml".path} auth_token";
          };
          availability.enabled = true;
          advanced = {
            last_seen = "ISO_8601";
            channel = config.mySystemConfig.smartHome.zigbee2mqtt.channel;
            pan_id = config.mySystemConfig.smartHome.zigbee2mqtt.panId;
            ext_pan_id = config.mySystemConfig.smartHome.zigbee2mqtt.extPanId;
            network_key = "!${config.sops.templates."zigbee2mqtt.yaml".path} network_key";
          };
        };
      };

      # Initial HTTP default; settings saved in Home Assistant UI take precedence.
      systemd.services.home-assistant.environment.SETUP_PORT = toString haPort;

      # Avoid the separate unauthenticated listener on configuration errors.
      systemd.services.zigbee2mqtt.environment.Z2M_ONBOARD_NO_SERVER = "1";

      sops.secrets = {
        "smart-home/mqtt_userpass/home-assistant" = { };
        "smart-home/mqtt_userpass/zigbee2mqtt" = { };
        "smart-home/zigbee2mqtt/frontend-token" = { };
        "smart-home/zigbee2mqtt/network-key" = { };
      };
      sops.templates."zigbee2mqtt.yaml" = {
        owner = config.systemd.services.zigbee2mqtt.serviceConfig.User;
        content = ''
          mqtt_password: '${config.sops.placeholder."smart-home/mqtt_userpass/zigbee2mqtt"}'
          auth_token: '${config.sops.placeholder."smart-home/zigbee2mqtt/frontend-token"}'
          network_key: ${config.sops.placeholder."smart-home/zigbee2mqtt/network-key"}
        '';
      };
    };
}
