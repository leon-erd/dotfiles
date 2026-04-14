{ ... }:

{
  flake.modules.nixos.users =
    { config, ... }:

    {
      # create users
      users.users = builtins.listToAttrs (
        map (user: {
          name = user.username;
          value = {
            isNormalUser = true;
            description = user.name;
            extraGroups = user.extraGroups;
          };
        }) config.myUsers
      );
    };
}
