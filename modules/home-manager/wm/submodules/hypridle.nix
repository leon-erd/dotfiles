{ pkgs, inputs, ... }:

{
  imports = [
    inputs.hypridle.homeManagerModules.hypridle
  ];

  services.hypridle = {
    enable = true;
    listeners = [
      {
        timeout = 500;
        onTimeout = "${pkgs.libnotify}/bin/notify-send timeout reached";
        onResume = "${pkgs.libnotify}/bin/notify-send service resumed";
      }
    ];
  };
}

