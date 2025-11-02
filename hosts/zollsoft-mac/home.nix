{
  lib,
  pkgs,
  userSettings,
  ...
}:

{
  imports = [
    ./hm-copy-apps.nix # https://github.com/nix-darwin/nix-darwin/pull/1396#issuecomment-2745290935
    ../../modules/home-manager/apps/misc.nix
    ../../modules/home-manager/apps/submodules/thunderbird.nix
    ../../modules/home-manager/devel/shell
    ../../modules/home-manager/devel/git.nix
    # ../../modules/home-manager/devel/python.nix
    ../../modules/home-manager/devel/vscode
    ../../modules/home-manager/devel/wezterm.nix
    ../../modules/home-manager/wm/aerospace
    ../../modules/home-manager/wm/useful_utilities/autoraise.nix
    ../../modules/home-manager/wm/useful_utilities/karabiner
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = "/Users/${userSettings.username}";
  xdg.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # dont manage toolbar bookmarks
  programs.firefox.profiles.${userSettings.username} = {
    settings = lib.mkForce {
      "browser.toolbars.bookmarks.visibility" = "never";
    };
    bookmarks = lib.mkForce { };
  };

  # custom init contents from client and server setup according to ZiWi
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

  home.packages = with pkgs; [
    betterdisplay
    postman
    slack
    spotify
  ];

  home.stateVersion = "25.05"; # Do not modify
}
