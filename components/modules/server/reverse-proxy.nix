{ ... }:

{
  flake.modules.nixos.reverseProxy =
    { config, lib, ... }:
    let
      domain = config.mySystemConfig.domain;
    in
    {
      # Deduplicate this dependency when several service modules import it.
      key = "dotfiles/nixos/reverseProxy";

      # Set these options as defaults for all virtual hosts
      options.services.nginx.virtualHosts = lib.mkOption {
        type =
          with lib.types;
          attrsOf (submodule {
            forceSSL = lib.mkDefault true;
            useACMEHost = lib.mkDefault domain;
            locations."@not_found".return = lib.mkDefault 404;
          });
      };

      config = {
        sops.secrets."ddnss/update_key" = { };

        security.acme = {
          acceptTerms = true;
          defaults = {
            email = config.mySystemConfig.acmeEmail;
            dnsProvider = "ddnss";
            credentialFiles.DDNSS_KEY_FILE = config.sops.secrets."ddnss/update_key".path;
          };
          certs.${domain} = {
            inherit domain;
            extraDomainNames = [ "*.${domain}" ];
            group = config.services.nginx.group;
          };
        };

        services.nginx = {
          enable = true;
          recommendedProxySettings = true;
          recommendedTlsSettings = true;
          recommendedOptimisation = true;
          commonHttpConfig = ''
            error_page 403 = @not_found;
            allow 127.0.0.1;
            allow ::1;
            allow ${config.mySystemConfig.localNetwork};
            deny all;
          '';
          # Reject the base domain and any hostname without its own virtual host.
          virtualHosts.${domain} = {
            default = true;
            extraConfig = "return 403;";
          };
        };

        networking.firewall.allowedTCPPorts = [
          80
          443
        ];
      };
    };
}
