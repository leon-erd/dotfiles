{ self, ... }:

{
  flake.modules.nixos.smartHome =
    {
      config,
      lib,
      options,
      pkgs,
      ...
    }:
    let
      haPort = 8123;
      z2mPort = 8081;
      mosquittoPort = 1883;
      speechToPhrasePort = 10300;
      piperPort = 10200;
    in
    {
      imports = [ self.modules.nixos.reverseProxy ];

      services.nginx.virtualHosts = {
        "ha.${config.mySystemConfig.domain}".locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:${toString haPort}";
            proxyWebsockets = true;
          };
          # Let the companion app send location updates from outside the local network.
          "/api/webhook/" = {
            proxyPass = "http://127.0.0.1:${toString haPort}";
            extraConfig = "allow all;";
          };
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
          "telegram_bot"
          "webdav"
          "workday"
          "wyoming"
        ];
        customComponents = [ pkgs.home-assistant-custom-components.ha_mcp_tools ];
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

      # Local speech-to-text for Assist. Language and recognizable sentences come from Home Assistant.
      systemd.services.speech-to-phrase = {
        description = "Wyoming speech-to-phrase";
        wants = [ "network-online.target" ];
        after = [
          "network-online.target"
          "home-assistant.service"
        ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          DynamicUser = true;
          StateDirectory = "speech-to-phrase";
          # Provides HASS_TOKEN.
          EnvironmentFile = config.sops.templates."speech-to-phrase.env".path;
          ExecStart = toString [
            (lib.getExe pkgs.speech-to-phrase)
            "--uri tcp://127.0.0.1:${toString speechToPhrasePort}"
            "--models-dir /var/lib/speech-to-phrase/models"
            "--train-dir /var/lib/speech-to-phrase/train"
            "--hass-websocket-uri ws://127.0.0.1:${toString haPort}/api/websocket"
            # Retrains only when exposed entities or sentences changed.
            "--retrain-on-connect"
          ];
        };
      };

      # Local text-to-speech for Assist.
      services.wyoming.piper.servers.assist = {
        enable = true;
        voice = "de_DE-thorsten-medium";
        uri = "tcp://127.0.0.1:${toString piperPort}";
        zeroconf.enable = false;
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
        "smart-home/speech-to-phrase/ha-token" = { };
      };
      sops.templates."speech-to-phrase.env".content = ''
        HASS_TOKEN=${config.sops.placeholder."smart-home/speech-to-phrase/ha-token"}
      '';
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
