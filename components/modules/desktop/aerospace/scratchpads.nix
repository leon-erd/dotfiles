{ ... }:

{
  flake.modules.homeManager.aerospaceScratchpads =
    {
      inputs,
      config,
      lib,
      pkgs,
      ...
    }:

    let
      mainMod = "ctrl-alt";
      scratchpad = inputs.aerospace-scratchpad.packages.${pkgs.stdenv.hostPlatform.system}.default;
      scratchpadToggle = pkgs.writers.writePython3Bin "aerospace-scratchpad-toggle" {
        libraries = [ ];
        flakeIgnore = [ "E501" ];
      } ./scratchpad.py;
      toggle =
        appName: title: command:
        "exec-and-forget ${lib.getExe scratchpadToggle} "
        + lib.escapeShellArgs (
          [
            "--aerospace"
            (lib.getExe config.programs.aerospace.package)
            "--scratchpad"
            (lib.getExe' scratchpad "aerospace-scratchpad")
            "--app-name"
            appName
            "--title"
            title
            "--fullscreen"
            "--"
          ]
          ++ command
        );
      terminal =
        title: command:
        [
          "/usr/bin/env"
          "WEZTERM_SCRATCHPAD_TITLE=${title}"
          (lib.getExe pkgs.wezterm)
          "start"
          "--always-new-process"
          "--"
        ]
        ++ command;
    in
    {
      programs.aerospace.settings = {
        exec-on-workspace-change = [
          "/bin/bash"
          "-c"
          ''${lib.getExe' scratchpad "aerospace-scratchpad"} hook pull-window "$AEROSPACE_PREV_WORKSPACE" "$AEROSPACE_FOCUSED_WORKSPACE"''
        ];
        workspace-to-monitor-force-assignment = {
          ".scratchpad.1" = 1;
          ".scratchpad.2" = 2;
          ".scratchpad.3" = 3;
        };
        mode.main.binding = {
          "${mainMod}-b" = toggle "wezterm-gui" "^(scratchpad-btop|btop)$" (
            terminal "scratchpad-btop" [ (lib.getExe pkgs.btop) ]
          );
          "${mainMod}-a" = toggle "Activity Monitor" "" [
            "/usr/bin/open"
            "-a"
            "Activity Monitor"
          ];
          "${mainMod}-e" = toggle "Finder" "" [
            "/usr/bin/open"
            "-a"
            "Finder"
          ];
          "${mainMod}-s" = toggle "Spotify" "" [
            "/usr/bin/open"
            "-a"
            "Spotify"
          ];
        };
      };
    };
}
