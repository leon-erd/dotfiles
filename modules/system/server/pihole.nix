{
  lib,
  pkgs,
  systemSettings,
  ...
}:

{
  services.pihole-ftl = {
    enable = true;
    openFirewallDHCP = true;
    openFirewallWebserver = true;
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
          # DNS.WATCH
          "84.200.69.80"
          "84.200.70.40"
          "2001:1608:10:25:0:0:1c04:b12f"
          "2001:1608:10:25:0:0:9249:d69b"
          # Cloudflare (with Malware Blocking and DNSSEC Validation)
          "9.9.9.9"
          "149.112.112.112"
          "2620:fe::fe"
          "2620:fe::9"
        ];
        # Array of custom DNS records each one in HOSTS form: "IP HOSTNAME"
        hosts = lib.mkIf (systemSettings ? pihole.hosts) systemSettings.pihole.hosts;
      };
      webserver = {
        tls = lib.mkForce {
          cert = "/var/lib/pihole/tls.pem";
        };
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
    ports = [
      "8080r"
      "8443s"
    ];
  };
}
