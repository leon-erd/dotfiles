{ config, lib, pkgs, ... }:

let
  myKanshiPlus = pkgs.writers.writePython3Bin "myKanshiPlus" {
    libraries = [];
    flakeIgnore = [ "E501" ];
  } ./script.py;

  cfg = config.programs.myKanshiPlus;
  inherit (lib.types) attrsOf enum float int nullOr oneOf submodule str;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkIf;

  monitor = submodule {
    options = {
      resolution = mkOption {
        type = str;
        default = "preferred";
        example = "1920x1080";
      };
      position = mkOption {
        type = str;
        default = "0x0";
      };
      scale = mkOption {
        type = oneOf [ int float (enum ["auto"]) ];
        default = 1;
        example = "auto";
      };
      mirror = mkOption {
        type = nullOr str;
        default = null;
        example = "LG Display 0x0637";
      };
      transform = mkOption {
        type = nullOr int;
        default = null;
        example = 2;
      };
    };
  };

  profile = submodule {
    options = {
      monitors = mkOption {
        type = attrsOf monitor;
        default = {};
        example = {
          "Dell Inc. DELL P2412H TTMDG2AQ15EU" = {};
          "LG Electronics E2210      205NDMT1D051" = {
            resolution = "1680x1050";
            position = "1920x0";
          };
        };
      };
      workspaces = mkOption {
        type = attrsOf str;
        default = {};
        example = {
          "5" = "monitor:desc:Acer Technologies CB271HU T85EE0018511, default:true, on-created-empty:firefox";
          "name:test" = "rounding:false, border:false";
        };
      };
    };
  }; 
in

{
  options.programs.myKanshiPlus = {
    enable = mkEnableOption "myKanshiPlus";
    profiles = mkOption {
      description = "Attribute set of monitor profiles";
      type = attrsOf profile;
      default = {};
    };
  };


  config = mkIf cfg.enable {
    home.packages = [ myKanshiPlus ];

    xdg.configFile."myKanshiPlus/config.json".text = builtins.toJSON cfg.profiles;

    systemd.user.services.myKanshiPlus = {
      Unit = {
        Description = "Dynamic display configuration";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
        Requires = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${myKanshiPlus}/bin/myKanshiPlus";
        Restart = "always";
        RestartSec = 10;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    wayland.windowManager.hyprland.settings = {
      source = [ "./monitors.conf" "./workspaces.conf" ];
    };

    home.activation.myKanshiPlus = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run [ -f ~/.config/hypr/monitors.conf ] || touch ~/.config/hypr/monitors.conf
      run [ -f ~/.config/hypr/workspaces.conf ] || touch ~/.config/hypr/workspaces.conf
    '';
  };

}
