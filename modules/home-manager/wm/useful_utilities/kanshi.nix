{ ... }:

{
  services.kanshi = {
    enable = true;
    systemdTarget = "graphical-session.target";
    profiles = {
      default.outputs = [
        {
          criteria = "eDP-1";
          mode = "1920x1080";
          scale = 1.0;
        }
      ];
      home_1.outputs = [
        {
          criteria = "Dell Inc. DELL P2412H TTMDG2AQ15EU";
          mode = "1920x1080";
          scale = 1.0;
          position = "0,0";
        }
        {
          criteria = "eDP-1";
          mode = "1920x1080";
          scale = 1.0;
          position = "1920,0";
        }
      ];
      home_2.outputs = [
        {
          criteria = "Dell Inc. DELL P2412H TTMDG2AQ15EU";
          mode = "1920x1080";
          scale = 1.0;
          position = "0,0";
        }
        {
          criteria = "LG Electronics E2210      205NDMT1D051";
          mode = "1680x1050";
          scale = 1.0;
          position = "1920,0";
        }
        {
          criteria = "eDP-1";
          mode = "1920x1080";
          scale = 1.0;
          position = "3600,0";
        }
      ];
      office.outputs = [
        {
          criteria = "eDP-1";
          mode = "1920x1080";
          scale = 1.0;
          position = "0,0";
        }
        {
          criteria = "Acer Technologies CB271HU T85EE0018511";
          mode = "2560x1440";
          scale = 1.0;
          position = "1920,0";
        }
      ];
    };
  };

  wayland.windowManager.hyprland.settings = {
    bind = [ "$mainMod + SHIFT, P, exec, pkill -HUP kanshi" ];
  };
}
