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
    ];
    misc.focus_on_activate = true;
  };
}
