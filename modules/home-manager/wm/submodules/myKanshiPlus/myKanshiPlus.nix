{ config, lib, pkgs, ... }:

{
  imports = [ ./module.nix ];

  programs.myKanshiPlus = {
    enable = true;
    profiles = {
      default.monitors."LG Display 0x0637" = {};
      home_1.monitors = {
        "Dell Inc. DELL P2412H TTMDG2AQ15EU" = {};
        "LG Display 0x0637".position = "1920x0";
      };
      home_2.monitors = {
        "Dell Inc. DELL P2412H TTMDG2AQ15EU" = {};
        "LG Electronics E2210      205NDMT1D051".position = "1920x0";
        "LG Display 0x0637".position = "3600x0";
      };
      office = {
        monitors = {
          "LG Display 0x0637" = {};
          "Acer Technologies CB271HU T85EE0018511".position = "1920x0";
        };
        workspaces = {
          "5" = "monitor:desc:Acer Technologies CB271HU T85EE0018511, default:true";
          "9" = "monitor:desc:Acer Technologies CB271HU T85EE0018511";
        };
      };
      mama = {
        monitors = {
          "LG Display 0x0637" = {};
          "Iiyama North America PLX2472HC 1153284900523".position = "1920x0";
        };
      };
    };
  };
}
