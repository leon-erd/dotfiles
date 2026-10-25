{ ... }:

{
  flake.modules.homeManager.python =
    { pkgs, ... }:

    {
      home.packages = with pkgs; [
        micromamba
      ];

      programs.zsh = {
        # The hook embeds the real binary path (.mamba-wrapped), which it rejects
        # as unknown MAMBA_EXE. Point it at the micromamba wrapper instead.
        # https://github.com/NixOS/nixpkgs/pull/522767
        initContent = ''
          eval "$(micromamba shell hook --shell zsh | sed 's|${pkgs.mamba-cpp}/bin/.mamba-wrapped|${pkgs.micromamba}/bin/micromamba|g')"
        '';
      };
    };
}
