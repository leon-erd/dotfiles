{ ... }:

{
  flake.modules.nixos.plymouth =
    { ... }:

    {
      boot.plymouth = {
        enable = true;
        theme = "solar";
      };
    };
}
