{ lib, pkgs, ... }:

{
  programs.aerospace = {
    enable = true;
    launchd.enable = true;
    settings = {
      after-startup-command = [
        "exec-and-forget ${lib.getExe pkgs.jankyborders} active_color=0xff00ff99 inactive_color=0xaa444444 width=5.0"
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
        cmd-alt-t = "exec-and-forget \${HOME}/Applications/Home\\ Manager\\ Apps/WezTerm.app/wezterm-gui";
        cmd-alt-s = "exec-and-forget ${lib.getExe pkgs.flameshot} gui";
        cmd-ctrl-alt-shift-b = "exec-and-forget ${./scratchpad.sh} --command btop";
        cmd-ctrl-alt-shift-a = "exec-and-forget ${./scratchpad.sh} --app-name \"Activity Monitor\"";
        cmd-ctrl-alt-shift-e = "exec-and-forget ${./scratchpad.sh} --app-name Finder";
        cmd-ctrl-alt-shift-s = "exec-and-forget ${./scratchpad.sh} --app-name Spotify";
        alt-f4 = "close --quit-if-last-window";
        alt-tab = "focus dfs-next --boundaries-action wrap-around-the-workspace";
        ctrl-f = "layout floating tiling";
        ctrl-m = "fullscreen --no-outer-gaps";
        ctrl-t = "layout tiles horizontal vertical";
        ctrl-plus = "resize smart +50";
        ctrl-minus = "resize smart -50";
        ctrl-alt-left = "move left";
        ctrl-alt-down = "move down";
        ctrl-alt-up = "move up";
        ctrl-alt-right = "move right";
        ctrl-shift-left = "join-with left";
        ctrl-shift-down = "join-with down";
        ctrl-shift-up = "join-with up";
        ctrl-shift-right = "join-with right";
        ctrl-cmd-left = "move-workspace-to-monitor left";
        ctrl-cmd-down = "move-workspace-to-monitor up";
        ctrl-cmd-up = "move-workspace-to-monitor down";
        ctrl-cmd-right = "move-workspace-to-monitor right";
        ctrl-1 = "workspace 1";
        ctrl-2 = "workspace 2";
        ctrl-3 = "workspace 3";
        ctrl-4 = "workspace 4";
        ctrl-5 = "workspace 5";
        ctrl-6 = "workspace 6";
        ctrl-7 = "workspace 7";
        ctrl-8 = "workspace 8";
        ctrl-9 = "workspace 9";
        ctrl-0 = "workspace 10";
        cmd-alt-tab = "workspace-back-and-forth";
        ctrl-shift-1 = "move-node-to-workspace 1";
        ctrl-shift-2 = "move-node-to-workspace 2";
        ctrl-shift-3 = "move-node-to-workspace 3";
        ctrl-shift-4 = "move-node-to-workspace 4";
        ctrl-shift-5 = "move-node-to-workspace 5";
        ctrl-shift-6 = "move-node-to-workspace 6";
        ctrl-shift-7 = "move-node-to-workspace 7";
        ctrl-shift-8 = "move-node-to-workspace 8";
        ctrl-shift-9 = "move-node-to-workspace 9";
        ctrl-shift-0 = "move-node-to-workspace 10";
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
          "if".app-id = "com.jetbrains.intellij.ce";
          run = "move-node-to-workspace 1";
        }
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
}
