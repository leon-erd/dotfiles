{ ... }:

{
  flake.modules.homeManager.latex =
    { pkgs, ... }:

    {
      home.packages = with pkgs; [
        ipe
        # jabref
        pympress
        texliveFull
      ];
    };
}
