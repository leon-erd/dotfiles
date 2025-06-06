{
  config,
  lib,
  pkgs,
  userSettings,
  ...
}:

let
  wireguardConfigPath = ../../../secrets/files/wireguard_clients/${userSettings.systemConfigurationName}.conf;

  hasWireguardConfig = builtins.pathExists wireguardConfigPath;

  vpnPiAliases = lib.optionalAttrs hasWireguardConfig {
    vpn_pi_on = "wg-quick up ${config.sops.secrets."wireguard.conf".path}";
    vpn_pi_off = "wg-quick down ${config.sops.secrets."wireguard.conf".path}";
  };

  myAliases = {
    clearswap = "sudo swapoff -a; sudo swapon -a";
    conda = "micromamba";
    fhs = "nix-shell -E 'with import <nixpkgs> {}; (pkgs.buildFHSUserEnv { name = \"fhs\"; runScript = \"zsh\"; }).env'";
    get_temp = "paste <(cat /sys/class/thermal/thermal_zone*/type) <(cat /sys/class/thermal/thermal_zone*/temp) | column -s $'\t' -t | sed 's/\(.\)..$/.\1°C/'";
    homie = "nh home switch --configuration ${userSettings.userConfigurationName}";
    nixie = "nh os switch --hostname ${userSettings.systemConfigurationName}";
    ls = "eza --icons --group-directories-first";
    ll = "eza --icons --group-directories-first --all --long --group";
    tree = "eza --icons --group-directories-first --tree";
    neofetch = "nix run nixpkgs\#fastfetch -- --config examples/7.jsonc";
    root_shell = "sudo env \"HOME=/home/$USER\" zsh --login";
    venv = "source venv/bin/activate";
  } // vpnPiAliases;
in
{
  sops.secrets = lib.optionalAttrs hasWireguardConfig {
    "wireguard.conf" = {
      format = "binary";
      sopsFile = wireguardConfigPath;
    };
  };

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
      custom = "$XDG_CONFIG_HOME/oh-my-zsh/custom";
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

  xdg.configFile."oh-my-zsh/custom/themes/robbyrussell.zsh-theme".text = ''
    # custom robbyrussell theme
    PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%~%{$reset_color%}"
    PROMPT+=' $(git_prompt_info)'
    RPROMPT="%{$fg_bold[magenta]%}[%n@%M]%{$reset_color%}"

    ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
    ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
    ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
  '';

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
