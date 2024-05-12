{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";

    bind = [
      # GENERAL
      "ALT, F4 , killactive,"
      "$mainMod, F, togglefloating,"
      "$mainMod, G, togglegroup"
      "$mainMod, M, fullscreen,"
      "$mainMod, E, exec, dolphin"

      # SPECIAL KEYS
      ", XF86Calculator , exec, qalculate-qt"

      # WINDOWS
      "$mainMod + SHIFT, left, movewindoworgroup, l"
      "$mainMod + SHIFT, right, movewindoworgroup, r"
      "$mainMod + SHIFT, up, movewindoworgroup, u"
      "$mainMod + SHIFT, down, movewindoworgroup, d"
      "$mainMod + CTRL, left, movecurrentworkspacetomonitor, l"
      "$mainMod + CTRL, right, movecurrentworkspacetomonitor, r"
      "$mainMod + CTRL, up, movecurrentworkspacetomonitor, u"
      "$mainMod + CTRL, down, movecurrentworkspacetomonitor, d"
      "$mainMod, RETURN, layoutmsg, swapwithmaster"
      "$mainMod + SHIFT, RETURN, layoutmsg, addmaster"
      "$mainMod + SHIFT + CTRL, RETURN, layoutmsg, removemaster"
      "ALT, Tab, cyclenext,"
      "ALT + CTRL, Tab, changegroupactive"

      # WORKSPACES
      # Switch workspaces with mainMod + [0-9]
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"
      "$mainMod, Tab, workspace, previous"

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
      "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
      "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
      "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
      "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
      "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
      "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
      "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
      "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
      "$mainMod SHIFT, 0, movetoworkspacesilent, 10"

      # Scroll through existing workspaces with mainMod + scroll
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"
    ];

    binde = [
      # WINDOWS
      "$mainMod, left, resizeactive, -30 0"
      "$mainMod, right, resizeactive, 30 0"
      "$mainMod, up, resizeactive, 0 -30"
      "$mainMod, down, resizeactive, 0 30"
    ];

    bindm = [
      # WINDOWS
      # Move/resize windows with mainMod + LMB/RMB and dragging
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    # Cycle workspaces with mainMod + Tab
    binds.allow_workspace_cycles = "yes";
  };
}
