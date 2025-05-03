{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      "float, class:^(org.kde.polkit-kde-authentication-agent-1)$"

      "tile, class:^(DesktopEditors)$"

      "tag +vscode, class:^(code-url-handler)$"
      "tag +vscode, class:^(codium-url-handler)$"
      "opacity 0.85, tag:vscode"
      "opacity 1.00, tag:vscode, title:.pdf"
      "workspace 1, tag:vscode"

      "workspace 5, class:^(firefox)$"

      "tag +social, class:^(org.telegram.desktop)$"
      "tag +social, class:^(signal)$"
      "tag +social, class:^(Slack)$"
      "tag +social, class:^(thunderbird)$"
      "tag +social, class:^(WebCord)$"
      "tag +social, class:^(whatsapp-for-linux)$"
      "workspace 9, tag:social"

      # KDE CONNECT Presentation Mode
      "noblur, class:^(org.kde.kdeconnect.daemon)$"
      "noborder, class:^(org.kde.kdeconnect.daemon)$"
      "noshadow, class:^(org.kde.kdeconnect.daemon)$"
      "noanim, class:^(org.kde.kdeconnect.daemon)$"
      "nofocus, class:^(org.kde.kdeconnect.daemon)$"
      "suppressevent fullscreen, class:^(org.kde.kdeconnect.daemon)$"
      "float, class:^(org.kde.kdeconnect.daemon)$"
      "move 0 0, class:^(org.kde.kdeconnect.daemon)$"
      "size 100% 100%, class:^(org.kde.kdeconnect.daemon)$"
    ];
  };
}
