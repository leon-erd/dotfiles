{ ... }:

{
  flake.modules.homeManager.hyprpolkit =
    { ... }:

    {
      services.hyprpolkitagent.enable = true;
    };
}
