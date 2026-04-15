{ ... }:

{
  flake.modules.homeManager.wireguardClient =
    {
      config,
      pkgs,
      inputs,
      ...
    }:
    {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];

      sops.secrets."wireguard.conf" = {
        format = "binary";
        sopsFile = config.myUserConfig.wireguardConfig;
      };

      home.packages = [ pkgs.wireguard-tools ];

      programs.zsh.shellAliases = {
        vpn_pi_on = "wg-quick up ${config.sops.secrets."wireguard.conf".path}";
        vpn_pi_off = "wg-quick down ${config.sops.secrets."wireguard.conf".path}";
      };

      programs.bash.shellAliases = {
        vpn_pi_on = "wg-quick up ${config.sops.secrets."wireguard.conf".path}";
        vpn_pi_off = "wg-quick down ${config.sops.secrets."wireguard.conf".path}";
      };
    };
}
