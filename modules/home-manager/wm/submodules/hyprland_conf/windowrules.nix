{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      "float, class:^(org.kde.polkit-kde-authentication-agent-1)$"

      "tile, class:^(DesktopEditors)$"

      "tag +vscode, class:^(code-url-handler)$"
      "tag +vscode, class:^(codium-url-handler)$"
      "opacity 0.85, tag:vscode"
      "opacity 1.00, tag:vscode, title:.pdf"
      "workspace 1, tag:vscode"

      "workspace 5, class:^(firefox)$"

      "tag +social, class:^(org.telegram.desktop)$"
      "tag +social, class:^(Signal)$"
      "tag +social, class:^(Slack)$"
      "tag +social, class:^(thunderbird)$"
      "tag +social, class:^(WebCord)$"
      "tag +social, class:^(whatsapp-for-linux)$"
      "workspace 9, tag:social"

      # KDE CONNECT Presentation Mode
      "noblur, title:KDE Connect Daemon"
      "noborder, title:KDE Connect Daemon"
      "noshadow, title:KDE Connect Daemon"
      "noanim, title:KDE Connect Daemon"
      "nofocus, title:KDE Connect Daemon"
      "suppressevent fullscreen, title:KDE Connect Daemon"
      "float, title:KDE Connect Daemon"
      "size 100% 100%, title:KDE Connect Daemon"
    ];
  };
}
