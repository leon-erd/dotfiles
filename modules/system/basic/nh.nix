{ ... }:

{
  programs.nh = { # nix helper for basic nix commands with added functionality
    enable = true;
    clean = {
      enable = true;
      dates = "daily";
      extraArgs = "--keep-since=7d --keep=5";
    };
  };
}