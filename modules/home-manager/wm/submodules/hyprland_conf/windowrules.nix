{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      "opacity 0.85, VSCodium"
      "float, org.kde.polkit-kde-authentication-agent-1"
      "tile, DesktopEditors"
      "workspace 1, VSCodium"
      "workspace 5, firefox"
      "workspace 9, org.telegram.desktop"
      "workspace 9, whatsapp-for-linux"
      "workspace 9, Signal"
      "workspace 9, Slack"
    ];
  };
}
