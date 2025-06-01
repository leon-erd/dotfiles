{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ./module.nix ];

  programs.myKanshiPlus = {
    enable = true;
    profiles = {
      default.monitors."LG Display 0x0637" = { };
      home_1.monitors = {
        "LG Display 0x0637" = { };
        "Dell Inc. DELL P2412H TTMDG2AQ15EU".position = "1920x0";
      };
      home_2 = {
        monitors = {
          "LG Display 0x0637" = { };
          "Dell Inc. DELL P2412H TTMDG2AQ15EU".position = "1920x0";
          "LG Electronics E2210      205NDMT1D051".position = "3840x0";
        };
        workspaces = {
          "1" = "monitor:desc:Dell Inc. DELL P2412H TTMDG2AQ15EU, default:true";
          "2" = "monitor:desc:LG Electronics E2210      205NDMT1D051, default:true";
          "10" = "monitor:desc:LG Display 0x0637, default:true";
        };
      };
      office = {
        monitors = {
          "LG Display 0x0637" = { };
          "Acer Technologies CB271HU T85EE0018511".position = "1920x0";
        };
        workspaces = {
          "1" = "monitor:desc:LG Display 0x0637, default:true";
          "2" = "monitor:desc:Acer Technologies CB271HU T85EE0018511";
          "5" = "monitor:desc:Acer Technologies CB271HU T85EE0018511, default:true";
          "9" = "monitor:desc:Acer Technologies CB271HU T85EE0018511";
        };
      };
      beamer.monitors = {
        "LG Display 0x0637" = { };
        "MS Telematica MStar Demo 0x00000001" = {
          position = "auto";
          mirror = "LG Display 0x0637";
        };
      };
    };
  };
}
