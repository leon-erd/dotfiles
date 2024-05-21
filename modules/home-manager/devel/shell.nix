{ userSettings, ... }:

let
myAliases = {
  pi = "ssh ubuntu@10.10.10.100";
  get_temp = "paste <(cat /sys/class/thermal/thermal_zone*/type) <(cat /sys/class/thermal/thermal_zone*/temp) | column -s $'\t' -t | sed 's/\(.\)..$/.\1°C/'";
  gall = "git pull && git add --all && git commit -v && git push";
  venv = "source venv/bin/activate";
  clearswap = "sudo swapoff -a; sudo swapon -a";
  ls = "eza --icons --group-directories-first";
  ll = "eza --icons --group-directories-first -al";
  tree = "eza --icons --tree --group-directories-first";
  conda = "micromamba";
  homie = "nh home switch --configuration user";
  nixie = "nh os switch --hostname system";
  };
in
{
  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    initExtra = ''
      bindkey '^[[Z' autosuggest-accept
      zstyle ':omz:plugins:alias-finder' autoload yes
    '';
    syntaxHighlighting.enable = true;
    shellAliases = myAliases;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = ["alias-finder" "command-not-found" "dirhistory" "fzf" "git" "pip" "sudo"];
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
  };
}
