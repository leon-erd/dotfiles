{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      "float, class:^(org.kde.polkit-kde-authentication-agent-1)$"
      "opacity 0.85, initialTitle:^(Visual Studio Code)$"
      "opacity 0.85, initialTitle:^(VSCodium)$"
      "opacity 1, initialTitle:^(Visual Studio Code)$, title:.pdf"
      "tile, class:^(DesktopEditors)$"
      "workspace 1, class:^(code-url-handler)$"
      "workspace 1, class:^(codium-url-handler)$"
      "workspace 5, class:^(firefox)$"
      "workspace 9, class:^(org.telegram.desktop)$"
      "workspace 9, class:^(Signal)$"
      "workspace 9, class:^(Slack)$"
      "workspace 9, class:^(WebCord)$"
      "workspace 9, class:^(whatsapp-for-linux)$"
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
