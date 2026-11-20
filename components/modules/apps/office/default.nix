{ self, ... }:

{
  flake.modules.homeManager.office =
    { pkgs, ... }:

    {
      imports = with self.modules.homeManager; [
        xournalpp
      ];

      home.packages = with pkgs; [
        qalculate-gtk
      ];

      programs.onlyoffice.enable = true;
    };
}
