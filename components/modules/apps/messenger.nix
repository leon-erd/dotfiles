{ ... }:

{
  flake.modules.homeManager.messenger =
    { pkgs, ... }:

    {
      home.packages = with pkgs; [
        signal-desktop
        slack
        telegram-desktop
        discord
        whatsie # whatsapp
      ];
    };
}
