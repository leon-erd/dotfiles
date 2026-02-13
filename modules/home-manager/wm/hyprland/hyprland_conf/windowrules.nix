{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      "match:class ^(org.kde.polkit-kde-authentication-agent-1)$, float on"

      "match:class ^(code)$, tag +vscode"
      "match:class ^(codium)$, tag +vscode"
      "match:tag vscode, opacity 0.85, workspace 1"
      "match:tag vscode, match:title .*\.pdf.*, opacity 1.00"

      "match:class ^(firefox), workspace 5$"

      "tag +social, match:class ^(discord)$"
      "tag +social, match:class ^(org.telegram.desktop)$"
      "tag +social, match:class ^(signal)$"
      "tag +social, match:class ^(Slack)$"
      "tag +social, match:class ^(thunderbird)$"
      "tag +social, match:class ^(wasistlos)$"
      "match:tag social, workspace 9"

      # KDE CONNECT Presentation Mode
      "match:class ^(org.kde.kdeconnect.daemon)$, no_blur on, border_size 0, no_shadow on, no_anim on, no_focus on, suppress_event fullscreen, float on, move 0 0, size 100% 100%"
    ];
  };
}
