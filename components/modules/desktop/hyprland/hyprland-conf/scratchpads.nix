{ ... }:

{
  flake.modules.homeManager.hyprlandScratchpads =
    { lib, pkgs, ... }:

    {
      wayland.windowManager.hyprland.settings = {
        workspace = [
          "special:btop, on-created-empty:[fullscreen] ${lib.getExe pkgs.wezterm} -e btop"
          "special:htop, border:false, on-created-empty:[float; size 100% 35%; move 0% 65%] ${lib.getExe pkgs.wezterm} -e htop"
          "special:spotify, on-created-empty:[fullscreen] spotify"
          "special:terminal, on-created-empty:[fullscreen] ${lib.getExe pkgs.wezterm}"
        ];
        bind = [
          "$mainMod, B, togglespecialworkspace, btop"
          "$mainMod, H, togglespecialworkspace, htop"
          "$mainMod, S, togglespecialworkspace, spotify"
          "$mainMod, T, togglespecialworkspace, terminal"
        ];
        animation = [
          "specialWorkspace, 1, 5, default, slidefadevert"
        ];
      };
    };
}
