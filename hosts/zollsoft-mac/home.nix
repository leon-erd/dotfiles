{
  lib,
  pkgs,
  inputs,
  userSettings,
  ...
}:

{
  imports = [
    ./hm-copy-apps.nix # https://github.com/nix-darwin/nix-darwin/pull/1396#issuecomment-2745290935
    ../../modules/home-manager/apps/misc.nix
    ../../modules/home-manager/devel/shell
    ../../modules/home-manager/devel/git.nix
    ../../modules/home-manager/devel/python.nix
    ../../modules/home-manager/devel/vscode
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = "/Users/${userSettings.username}";
  xdg.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.firefox.profiles.${userSettings.username}.bookmarks = lib.mkForce { };

  programs.zsh.initContent = ''
    export PATH=$PATH:/opt/homebrew/opt/libpq/bin$PATH:/opt/homebrew/bin
    export PATH="/usr/local/bin:$PATH"
    export PATH="$PATH":"$HOME/.pub-cache/bin"
    ## [Completion]
    ## Completion scripts setup. Remove the following line to uninstall
    [[ -f /Users/leon.erd/.dart-cli-completion/zsh-config.zsh ]] && . /Users/leon.erd/.dart-cli-completion/zsh-config.zsh || true
    ## [/Completion]
    eval "$(rbenv init - zsh)"
    export LANG=en_US.UTF-8
  '';

  programs.vscode.package = lib.mkForce pkgs.vscode;

  home.packages = with pkgs; [
    spotify
  ];

  home.stateVersion = "25.05"; # Do not modify
}
