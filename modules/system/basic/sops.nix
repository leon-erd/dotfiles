{ systemSettings, ... }:

{
  sops = {
    age.keyFile = "/home/${systemSettings.users."1".username}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
  };

  # set up ssh keys for users
  sops.secrets = builtins.listToAttrs (
    builtins.map (user: {
      name = "ssh/private_keys/${user.username}@${systemSettings.hostname}";
      value = {
        owner = user.username;
        mode = "600";
        path = "/home/${user.username}/.ssh/id_ed25519";
      };
    }) (builtins.attrValues systemSettings.users)
  );
}
