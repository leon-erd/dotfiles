{ ... }:

{
  flake.modules.homeManager.dotfilesUpdate =
    { config, pkgs, ... }:

    let
      git = "git -C ${config.myUserConfig.flakeDirectory}";
      hasLocalChanges = ''[ -n "$(${git} status --porcelain)" ]'';
      resetToUpstream = "${git} reset --hard '@{u}'";

      # update the dotfiles to the upstream state, local changes are kept
      # (only stash when there are any, otherwise `stash pop` would restore an unrelated old stash)
      updateDotfiles = "${git} fetch origin && if ${hasLocalChanges}; then ${git} stash push --include-untracked && ${resetToUpstream} && ${git} stash pop; else ${resetToUpstream}; fi";

      aliases = config.programs.zsh.shellAliases;
      switchSystem = if pkgs.stdenv.hostPlatform.isDarwin then aliases.darwie else aliases.nixie;

      updateAll = pkgs.writeShellApplication {
        name = "update";
        runtimeInputs = with pkgs; [
          boxes
          cowsay
          figlet
          lolcat
        ];
        text = ''
          # big figlet text in the speech bubble (-n: no word wrapping), colored by lolcat
          banner() {
            { figlet "$1"; echo; echo "$2"; } | cowsay -n -f stegosaurus | lolcat
          }

          # runs a command, if it fails the banner is shown and the whole script stops
          run_step() {
            local label=$1
            shift
            echo
            figlet "$label" | boxes | lolcat
            if ! "$@"; then
              echo
              banner "FEHLER" "Fehlgeschlagen: $label"
              exit 1
            fi
          }

          update_dotfiles() { ${updateDotfiles}; }

          # usage: update [--no-pull]
          update_repo=true
          for arg in "$@"; do
            case $arg in
              --no-pull) update_repo=false ;;
              *)
                echo "Usage: update [--no-pull]" >&2
                exit 2
                ;;
            esac
          done

          # nh only asks for the sudo password in the system step, after the long build.
          # Ask once at the start instead and keep the credentials fresh until the script ends.
          run_step "Sudo password" sudo -v
          (
            while true; do
              sleep 60
              kill -0 "$$" || exit
              sudo -n -v || exit
            done
          ) 2>/dev/null &
          keepalive_pid=$!
          trap 'kill "$keepalive_pid"' EXIT

          if [ "$update_repo" = true ]; then
            run_step "Repo update" update_dotfiles
          fi
          run_step "System update" ${switchSystem}
          run_step "Home update" ${aliases.homie}

          echo
          banner "ALLES OK" "Keine Probleme, alles aktuell."
        '';
      };
    in
    {
      home.shellAliases.update-dotfiles = updateDotfiles;
      home.packages = [ updateAll ];
    };
}
