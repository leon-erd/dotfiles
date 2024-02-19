{ pkgs, ... }:

{
  home.packages = with pkgs; [
    onlyoffice-bin
    qalculate-gtk
    xournalpp
  ];
}
