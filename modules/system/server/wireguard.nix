{
  pkgs,
  config,
  systemSettings,
  ...
}:

{
  sops.secrets = {
    "wireguard/server/private_key" = {
    };
  };

  networking.nat.enable = true;
  networking.nat.externalInterface = systemSettings.wireguard.externalInterface;
  networking.nat.internalInterfaces = [ "wg0" ];
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.1/24" ];
      listenPort = 51820;
      privateKeyFile = config.sops.secrets."wireguard/server/private_key".path;

      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ${systemSettings.wireguard.externalInterface} -j MASQUERADE
        ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -o ${systemSettings.wireguard.externalInterface} -j ACCEPT
        ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -o wg0 -j ACCEPT
      '';

      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o ${systemSettings.wireguard.externalInterface} -j MASQUERADE
        ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -o ${systemSettings.wireguard.externalInterface} -j ACCEPT
        ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -o wg0 -j ACCEPT
      '';

      peers = systemSettings.wireguard.clientPeers;
    };
  };
}
