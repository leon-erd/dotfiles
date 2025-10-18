{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [ inputs.caelestia-shell.homeManagerModules.default ];

  programs.caelestia = {
    enable = true;
    # https://github.com/caelestia-dots/shell/issues/390
    systemd.environment = [ "QT_QPA_PLATFORMTHEME=gtk3" ];
    cli = {
      enable = true;
      settings = {
        theme = {
          enableTerm = false;
          enableHypr = false;
          enableDiscord = false;
          enableSpicetify = false;
          enableFuzzel = false;
          enableBtop = false;
          enableGtk = false;
          enableQt = false;
        };
      };
    };
    settings = {
      appearance = {
        font.family = {
          mono = "NotoMonoNerdFont";
          sans = "NotoSansNerdFont";
        };
        transparency = {
          enabled = true;
          base = 0.75;
          layers = 0.5;
        };
      };
      general = {
        apps.terminal = [ "${lib.getExe pkgs.alacritty}" ];
        idle.timeouts = [
          # {
          #   timeout = 180;
          #   idleAction = "lock";
          # }
        ];
      };
      background = {
        desktopClock.enabled = false;
        visualiser.enabled = true;
      };
      paths = {
        mediaGif = ./gifs/moose.gif;
        sessionGif = ./gifs/lightning.gif;
        wallpaperDir = "/home/leon/Nextcloud/Pictures/Geordnet";
      };
      bar = {
        clock.showIcon = false;
        entries = [
          {
            id = "logo";
            enabled = false;
          }
          {
            id = "clock";
            enabled = true;
          }
          {
            id = "activeWindow";
            enabled = true;
          }
          {
            id = "spacer";
            enabled = true;
          }
          {
            id = "workspaces";
            enabled = true;
          }
          {
            id = "spacer";
            enabled = true;
          }
          {
            id = "tray";
            enabled = true;
          }
          {
            id = "statusIcons";
            enabled = true;
          }
          {
            id = "power";
            enabled = true;
          }
        ];
        status = {
          showAudio = true;
          showMicrophone = true;
        };
        tray = {
          background = true;
        };
        workspaces = {
          showWindows = false;
          label = "";
          activeLabel = "";
          occupiedLabel = "";
          shown = 10;
          activeTrail = true;
        };
      };
      border = {
        thickness = 1;
        rounding = 20;
      };
      launcher = {
        showOnHover = false;
        actionPrefix = "/";
      };
      osd.enableMicrophone = true;
    };
  };

  wayland.windowManager.hyprland.settings = {
    bindr = [
      "$mainMod, $mainMod_L, exec, caelestia shell drawers toggle launcher"
      "$mainMod, L, exec, caelestia shell lock lock"
    ];

    bind = [
      "$mainMod, N, exec, caelestia shell drawers toggle sidebar"
      "$mainMod, D, exec, caelestia shell drawers toggle dashboard"
      ", Print, exec, caelestia screenshot --region --freeze"
      "CTRL + ALT, S, exec, ${pkgs.wl-clipboard}/bin/wl-paste | ${lib.getExe pkgs.swappy} -f -"
      # https://github.com/caelestia-dots/shell/issues/390
      "CTRL + ALT, B, exec, caelestia shell -k; QT_QPA_PLATFORMTHEME=gtk3 caelestia shell -d"
      "CTRL + ALT, W, exec, ~/scripts/wallpaper/select_image.sh && ~/scripts/wallpaper/update_wallpaper_caelestia.sh"
    ];

    # Media controls
    bindl = [
      ", XF86AudioPlay, global, caelestia:mediaToggle"
      ", XF86AudioStop, global, caelestia:mediaStop"
      ", XF86AudioPrev, global, caelestia:mediaPrev"
      ", XF86AudioNext, global, caelestia:mediaNext"
      "CTRL, left, global, caelestia:mediaPrev"
      "CTRL, right, global, caelestia:mediaNext"
    ];

    bindle = [
      # Audio controls
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 0.05+"
      ", XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-"
      "SHIFT, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      "SHIFT, XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SOURCE@ 0.05+"
      "SHIFT, XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0; wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 0.05-"
      # Brightness controls
      ", XF86MonBrightnessUp, global, caelestia:brightnessUp"
      ", XF86MonBrightnessDown, global, caelestia:brightnessDown"
    ];

    layerrule = [
      "blur, caelestia-.*"
      "blur, qs-.*"
      "blurpopups, caelestia-.*"
      "ignorealpha 0.1, caelestia-.*"
    ];

    permission = [
      "/nix/store/[a-z0-9]{32}-quickshell-wrapped-[0-9.]*/bin/.quickshell-wrapped, screencopy, allow"
    ];

    general.gaps_out = lib.mkForce 10;
    decoration.rounding = lib.mkForce 10;
  };
}
