{ ... }:

{
  flake.modules.nixos.sops =
    {
      config,
      lib,
      inputs,
      ...
    }:

    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      sops = {
        age.keyFile = "/home/${(lib.head config.myUsers).username}/.config/sops/age/keys.txt";
        defaultSopsFile = ../../secrets/secrets.yaml;
        defaultSopsFormat = "yaml";
      };

      # set up ssh keys for users
      sops.secrets = builtins.listToAttrs (
        map (user: {
          name = "ssh/private_keys/${user.username}@${config.mySystemConfig.hostname}";
          value = {
            owner = user.username;
            mode = "600";
            path = "/home/${user.username}/.ssh/id_ed25519";
          };
        }) config.myUsers
      );
    };

  flake.modules.homeManager.sops =
    { config, inputs, ... }:

    {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];
      
      sops = {
        age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        defaultSopsFile = ../../secrets/secrets.yaml;
        defaultSopsFormat = "yaml";
      };
    };
}
