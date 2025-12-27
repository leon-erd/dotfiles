{ inputs, ... }:

{
  imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

  # https://github.com/nix-community/stylix/issues/267#issuecomment-2314636091
  programs.plasma = {
    enable = true;
    configFile.kded5rc = {
      "Module-gtkconfig"."autoload" = false;
    };
  };
}
