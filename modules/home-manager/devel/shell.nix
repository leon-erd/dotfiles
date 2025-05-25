{ pkgs, userSettings, ... }:

let
  myAliases = {
    clearswap = "sudo swapoff -a; sudo swapon -a";
    conda = "micromamba";
    fhs = "nix-shell -E 'with import <nixpkgs> {}; (pkgs.buildFHSUserEnv { name = \"fhs\"; runScript = \"zsh\"; }).env'";
    get_temp = "paste <(cat /sys/class/thermal/thermal_zone*/type) <(cat /sys/class/thermal/thermal_zone*/temp) | column -s $'\t' -t | sed 's/\(.\)..$/.\1°C/'";
    homie = "nh home switch --configuration ${userSettings.userConfigurationName}";
    nixie = "nh os switch --hostname ${userSettings.systemConfigurationName}";
    ls = "eza --icons --group-directories-first";
    ll = "eza --icons --group-directories-first --all --long";
    tree = "eza --icons --group-directories-first --tree";
    neofetch = "nix run nixpkgs\#fastfetch -- --config examples/7.jsonc";
    root_shell = "sudo env \"HOME=/home/$USER\" zsh --login";
    venv = "source venv/bin/activate";
  };
in
{
  # packages for vpn aliases
  home.packages = with pkgs; [
    wireguard-tools
  ];

  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    initContent = ''
      bindkey '^[[Z' autosuggest-accept
      zstyle ':omz:plugins:alias-finder' autoload yes
    '';
    syntaxHighlighting.enable = true;
    shellAliases = myAliases;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "alias-finder"
        "command-not-found"
        "dirhistory"
        "fzf"
        "git"
        "pip"
        "sudo"
      ];
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = myAliases;
  };

  programs.zoxide = {
    enable = true;
    options = [
      "--cmd cd"
    ];
  };

  home.sessionVariables = {
    FLAKE = userSettings.flakeDirectory;
    NH_FLAKE = userSettings.flakeDirectory;
  };
}
