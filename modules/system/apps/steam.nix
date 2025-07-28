{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true; # with `gamescope %command%` in games launch options: start game in optimised microcompositor (may help if game has problems with resolutions)
  };

  environment.systemPackages = with pkgs; [
    mangohud # with `mangohud %command%` in games launch options: show performance overlay
    protonplus
  ];

  programs.gamemode.enable = true; # with `gamemoderun %command%` in games launch options: improve game performance with a set of optimizations
}
