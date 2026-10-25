{ ... }:

{
  flake.modules.nixos.fonts =
    { pkgs, ... }:

    {
      # Only install the nerd fonts that are referenced in the configuration, the full set is several GB.
      fonts.packages = with pkgs.nerd-fonts; [
        hack
        jetbrains-mono
        noto
        symbols-only # nerd icons as fallback for all other fonts
      ];

      fonts.fontconfig.defaultFonts = {
        monospace = [
          "Hack Nerd Font Mono"
          "JetBrainsMono Nerd Font"
        ];
      };
    };
}
