{ self, ... }:

{
  flake.modules.nixos.pihole =
    {
      lib,
      pkgs,
      config,
      ...
    }:

    let
      hostName = "dns.${config.mySystemConfig.domain}";
      webListenAddress = "127.0.0.1:8080";
      localNetwork = config.mySystemConfig.localNetwork;
      networkAddress = lib.head (lib.splitString "/" localNetwork);
      localDnsServer = "${lib.concatStringsSep "." (lib.take 3 (lib.splitString "." networkAddress))}.1";
    in
    {
      imports = [ self.modules.nixos.reverseProxy ];

      services.pihole-ftl = {
        enable = true;
        openFirewallDNS = true;
        openFirewallDHCP = true;
        openFirewallWebserver = false;
        lists = [
          {
            url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
          }
          {
            url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt";
          }
        ];
        settings = {
          dns = {
            upstreams = [
              # quad9 (with Malware Blocking and DNSSEC Validation)
              "9.9.9.9"
              "149.112.112.112"
              "2620:fe::fe"
              "2620:fe::9"
              # DNS.WATCH
              "84.200.69.80"
              "84.200.70.40"
              "2001:1608:10:25:0:0:1c04:b12f"
              "2001:1608:10:25:0:0:9249:d69b"
            ];
            # Array of custom DNS records each one in HOSTS form: "IP HOSTNAME"
            hosts = lib.unique (
              config.mySystemConfig.pihole.hosts
              # Additional entries that resolve all virtual hosts on the reverse proxy to the local ip
              ++ map (name: "${config.mySystemConfig.localIp} ${name}") (
                builtins.attrNames config.services.nginx.virtualHosts
              )
            );
            # https://docs.pi-hole.net/ftldns/configfile/#revservers
            revServers = [ "true,${localNetwork},${localDnsServer},fritz.box" ];
          };
          webserver = {
            paths = {
              webroot = lib.mkForce "${pkgs.runCommand "pihole-web-under-admin" { } ''
                mkdir -p $out
                ln -sf ${pkgs.pihole-web}/share $out/admin
              ''}";
              webhome = lib.mkForce "/admin/";
            };
          };
        };
      };

      services.pihole-web = {
        enable = true;
        hostName = hostName;
        # Allow connection only through the reverse proxy
        # https://docs.pi-hole.net/ftldns/configfile/#port_1
        ports = [ webListenAddress ];
      };

      services.nginx.virtualHosts.${hostName} = {
        locations."/" = {
          proxyPass = "http://${webListenAddress}";
          proxyWebsockets = true;
        };
      };
    };
}
