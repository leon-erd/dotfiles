{ ... }:

{
  flake.modules.homeManager.python =
    { pkgs, ... }:

    {
      home.packages = with pkgs; [
        micromamba
      ];

      programs.zsh = {
        initContent = "eval \"$(micromamba shell hook --shell zsh)\"";
      };
    };
}
