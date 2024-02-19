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
  homie = "home-manager switch --flake ${userSettings.flakeDirectory}/#user && echo '-------------------------\nnix profile diff-closures:\n...' && nix profile diff-closures --profile ~/.local/state/nix/profiles/home-manager | tail -n 50";
  nixie = "sudo nixos-rebuild switch --flake ${userSettings.flakeDirectory}/#system && echo '-------------------------\nnix profile diff-closures:\n...' && nix profile diff-closures --profile /nix/var/nix/profiles/system | tail -n 50";
  };
in
{
  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = true;
    initExtra = "bindkey '^[[Z' autosuggest-accept";
    syntaxHighlighting.enable = true;
    shellAliases = myAliases;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = ["git" "pip"];
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
}
