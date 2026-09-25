{ self, ... }:

{
  flake.modules.nixos.n8n =
    { config, ... }:
    let
      cfg = config.services.n8n;
      hostName = "n8n.${config.mySystemConfig.domain}";
    in
    {
      imports = [ self.modules.nixos.reverseProxy ];

      services.n8n = {
        enable = true;
        openFirewall = false;
        environment = {
          N8N_LISTEN_ADDRESS = "127.0.0.1";
          N8N_PROXY_HOPS = 1;
          N8N_WEBHOOK_URL = "https://${hostName}/";
        };
      };

      services.nginx.virtualHosts.${hostName} = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${cfg.environment.N8N_PORT}";
          proxyWebsockets = true;
        };
      };
    };
}
