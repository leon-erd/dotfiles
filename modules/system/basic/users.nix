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
}
