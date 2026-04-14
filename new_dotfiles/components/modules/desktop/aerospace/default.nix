{ ... }:

{
  flake.modules.homeManager.aerospace =
    { lib, pkgs, ... }:

    let
      mainMod = "ctrl-alt";
    in
    {
      programs.aerospace = {
        enable = true;
        launchd.enable = true;
        settings = {
          after-startup-command = [
            "exec-and-forget ${lib.getExe pkgs.jankyborders} active_color=0xff00ff99 inactive_color=0xaa444444 width=5.0"
            "exec-and-forget ${lib.getExe pkgs.autoraise} -delay 0"
          ];
          automatically-unhide-macos-hidden-apps = true;
          default-root-container-layout = "tiles";
          default-root-container-orientation = "auto";
          enable-normalization-flatten-containers = true;
          enable-normalization-opposite-orientation-for-nested-containers = true;
          exec-on-workspace-change = [ ]; # sketchybar
          gaps = {
            inner = {
              horizontal = 3;
              vertical = 3;
            };
            outer = {
              left = 5;
              bottom = 5;
              top = 5;
              right = 5;
            };
          };
          on-focus-changed = [ "move-mouse monitor-lazy-center" ];
          on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
          exec.env-vars.PATH = "\${PATH}:\${HOME}/.nix-profile/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin";
          key-mapping = {
            preset = "qwerty";
            key-notation-to-key-code = {
              y = "z";
              z = "y";
              minus = "slash";
              plus = "rightSquareBracket";
              backtick = "equal";
            };
          };
          mode.main.binding = {
            "cmd-alt-t" = "exec-and-forget \${HOME}/Applications/Home\\ Manager\\ Apps/WezTerm.app/wezterm-gui";
            "cmd-alt-s" = "exec-and-forget ${lib.getExe pkgs.flameshot} gui";
            "${mainMod}-b" = "exec-and-forget ${./scratchpad.sh} --command btop";
            "${mainMod}-a" = "exec-and-forget ${./scratchpad.sh} --app-name \"Activity Monitor\"";
            "${mainMod}-e" = "exec-and-forget ${./scratchpad.sh} --app-name Finder";
            "${mainMod}-s" = "exec-and-forget ${./scratchpad.sh} --app-name Spotify";
            "alt-f4" = "close --quit-if-last-window";
            "alt-tab" = "focus dfs-next --boundaries-action wrap-around-the-workspace";
            "${mainMod}-f" = "layout floating tiling";
            "${mainMod}-m" = "fullscreen --no-outer-gaps";
            "${mainMod}-t" = "layout tiles horizontal vertical";
            "${mainMod}-plus" = "resize smart +50";
            "${mainMod}-minus" = "resize smart -50";
            "${mainMod}-left" = "move left";
            "${mainMod}-down" = "move down";
            "${mainMod}-up" = "move up";
            "${mainMod}-right" = "move right";
            "${mainMod}-shift-left" = "join-with left";
            "${mainMod}-shift-down" = "join-with down";
            "${mainMod}-shift-up" = "join-with up";
            "${mainMod}-shift-right" = "join-with right";
            "${mainMod}-cmd-left" = "move-workspace-to-monitor left";
            "${mainMod}-cmd-down" = "move-workspace-to-monitor up";
            "${mainMod}-cmd-up" = "move-workspace-to-monitor down";
            "${mainMod}-cmd-right" = "move-workspace-to-monitor right";
            "${mainMod}-1" = "workspace 1";
            "${mainMod}-2" = "workspace 2";
            "${mainMod}-3" = "workspace 3";
            "${mainMod}-4" = "workspace 4";
            "${mainMod}-5" = "workspace 5";
            "${mainMod}-6" = "workspace 6";
            "${mainMod}-7" = "workspace 7";
            "${mainMod}-8" = "workspace 8";
            "${mainMod}-9" = "workspace 9";
            "${mainMod}-0" = "workspace 10";
            "${mainMod}-tab" = "workspace-back-and-forth";
            "${mainMod}-shift-1" = "move-node-to-workspace 1";
            "${mainMod}-shift-2" = "move-node-to-workspace 2";
            "${mainMod}-shift-3" = "move-node-to-workspace 3";
            "${mainMod}-shift-4" = "move-node-to-workspace 4";
            "${mainMod}-shift-5" = "move-node-to-workspace 5";
            "${mainMod}-shift-6" = "move-node-to-workspace 6";
            "${mainMod}-shift-7" = "move-node-to-workspace 7";
            "${mainMod}-shift-8" = "move-node-to-workspace 8";
            "${mainMod}-shift-9" = "move-node-to-workspace 9";
            "${mainMod}-shift-0" = "move-node-to-workspace 10";
            # alt-e = ''
            #   exec-and-forget osascript -e '
            #     tell application "Finder"
            #       make new Finder window to home
            #       activate
            #     end tell'
            # '';
          };
          on-window-detected = [
            {
              "if".app-id = "com.google.android.studio";
              run = "move-node-to-workspace 3";
            }
            {
              "if".app-id = "com.zollsoft.air";
              run = "move-node-to-workspace 4";
            }
            {
              "if".app-id = "org.nixos.firefox";
              run = "move-node-to-workspace 5";
            }
            {
              "if".app-id = "com.tinyspeck.slackmacgap";
              run = "move-node-to-workspace 9";
            }
            {
              "if".app-id = "com.gather.Gather";
              run = "move-node-to-workspace 9";
            }
            {
              "if".app-id = "com.zollsoft.arzeko";
              run = "move-node-to-workspace 10";
            }
          ];
        };
      };
    };
}
