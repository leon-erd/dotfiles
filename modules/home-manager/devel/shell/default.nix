{
  config,
  lib,
  pkgs,
  userSettings,
  ...
}:

let
  hasWireguardConfig = userSettings ? wireguardConfig;

  vpnPiAliases = lib.optionalAttrs hasWireguardConfig {
    vpn_pi_on = "wg-quick up ${config.sops.secrets."wireguard.conf".path}";
    vpn_pi_off = "wg-quick down ${config.sops.secrets."wireguard.conf".path}";
  };

  myAliases = {
    clearswap = "sudo swapoff -a; sudo swapon -a";
    conda = "micromamba";
    fhs = "nix-shell -E 'with import <nixpkgs> {}; (pkgs.buildFHSUserEnv { name = \"fhs\"; runScript = \"zsh\"; }).env'";
    get-temp = ''
      paste <(cat /sys/class/thermal/thermal_zone*/type) \
            <(cat /sys/class/thermal/thermal_zone*/temp) | \
            awk -F'\t' '{printf "%s\t%.1f°C\n", $1, $2/1000}' | \
            column -s $'\t' -t
    '';
    homie = "nh home switch --configuration ${userSettings.userConfigurationName}";
    nixie = "nh os switch --hostname ${userSettings.systemConfigurationName}";
    neofetch = "nix run nixpkgs\#fastfetch -- --config examples/7.jsonc";
    root-shell = "sudo env \"HOME=/home/$USER\" zsh --login";
    tree = "eza --tree";
    venv = "source venv/bin/activate";
  }
  // vpnPiAliases;

  myLessfilter = pkgs.writeShellApplication {
    name = "my-lessfilter";

    runtimeInputs = with pkgs; [
      bat
      chafa
      eza
      file
      gnused
      hr
      poppler-utils
    ];

    text = builtins.readFile ./lessfilter;
  };
in
{
  sops.secrets = lib.optionalAttrs hasWireguardConfig {
    "wireguard.conf" = {
      format = "binary";
      sopsFile = userSettings.wireguardConfig;
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
    syntaxHighlighting.enable = true;
    shellAliases = myAliases;
    oh-my-zsh = {
      enable = true;
      theme = ""; # "robbyrussell"; # use custom starship theme below
      custom = "$XDG_CONFIG_HOME/oh-my-zsh/custom";
      plugins = [
        "alias-finder"
        # https://github.com/NixOS/nixpkgs/issues/171054
        # https://blog.nobbz.dev/blog/2023-02-27-nixos-flakes-command-not-found/
        # sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos && sudo nix-channel --update
        "command-not-found"
        "dirhistory"
        "eza"
        "fzf"
        "git"
        "pip"
        "rsync"
        "sudo"
      ];
    };
    plugins = [
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
    ];
    initContent = ''
      # shift-tab to accept autosuggestions
      bindkey '^[[Z' autosuggest-accept

      # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/alias-finder
      zstyle ':omz:plugins:alias-finder' autoload yes

      # https://github.com/Aloxaf/fzf-tab?tab=readme-ov-file#configure
      zstyle ':completion:*:git-checkout:*' sort false
      zstyle ':completion:*:descriptions' format '[%d]' 
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:*' fzf-flags --bind=tab:accept --style=full --height=20 #--height=-2
      zstyle ':fzf-tab:*' switch-group '<' '>'

      # https://github.com/Aloxaf/fzf-tab/wiki/Preview
      # preview for systemctl
      zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
      # preview for env vars
      zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ''${(P)word}'
      # disable preview for command options and subcommands
      zstyle ':fzf-tab:complete:*:options' fzf-preview
      zstyle ':fzf-tab:complete:*:argument-1' fzf-preview
      # use less with custom lessfilter for anything else
      zstyle ':fzf-tab:complete:*:*' fzf-preview 'less ''${(Q)realpath}'
      export LESSOPEN='|${lib.getExe myLessfilter} %s'
    '';
  };

  # https://github.com/NixOS/nixpkgs/pull/416425
  programs.command-not-found.enable = true;

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$all";
      character = {
        success_symbol = "[➜](fg:green)";
        error_symbol = "[➜](fg:red)";
      };
      conda.disabled = true; # conda has its own prompt modifier, you could also disable that instead with `conda config --set changeps1 False`
      line_break.disabled = true;
      directory.format = "[$path]($style) [$read_only]($read_only_style)";
      git_status = {
        style = "bold purple";
        format = "([\\($all_status$ahead_behind\\)]($style) )";
      };
      hostname = {
        ssh_symbol = "🌐";
        style = "bold blue";
      };
      username.style_user = "bold blue";
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

  programs.eza = {
    enable = true;
    icons = "auto";
    extraOptions = [
      "--color-scale=all"
      "--group"
      "--group-directories-first"
      "--header"
      "--hyperlink"
    ];
  };

  home.sessionVariables = {
    FLAKE = userSettings.flakeDirectory;
    NH_FLAKE = userSettings.flakeDirectory;
  };
}
