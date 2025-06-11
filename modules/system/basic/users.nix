{ systemSettings, ... }:

{
  # create users
  users.users = builtins.listToAttrs (
    builtins.map (user: {
      name = user.username;
      value = {
        isNormalUser = true;
        description = user.name;
        extraGroups =
          user.extraGroups or [
            "networkmanager"
            "wheel"
          ];
      };
    }) (builtins.attrValues systemSettings.users)
  );

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
