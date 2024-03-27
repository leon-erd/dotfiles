{ pkgs, ... }:

{
  home.packages = with pkgs; [
    pamixer
    playerctl
    swayosd
  ];

  wayland.windowManager.hyprland.settings = {
    bindl = [
      ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioStop, exec, playerctl stop"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioNext, exec, playerctl next"
      "CTRL, left, exec, playerctl previous"
      "CTRL, right, exec, playerctl next"
    ];

    bindle = [
      ", XF86AudioRaiseVolume, exec, pamixer --unmute; swayosd-client --output-volume raise"
      ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
      ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
      ", XF86AudioLowerVolume, exec, pamixer --unmute; swayosd-client --output-volume lower"
    ];

    exec-once = [
      "swayosd-server"
    ];

    layerrule = [
      "blur, swayosd"
      "ignorezero, swayosd"
    ];
  };
}
