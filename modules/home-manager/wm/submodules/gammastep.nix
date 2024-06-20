{ ... }:

{
  services.gammastep = {
    enable = true;
#     provider = "geoclue2"; # https://github.com/NixOS/nixpkgs/issues/321121
    provider = "manual";
    latitude = 47.3;
    longitude = 11.4;
    tray = true;
  };
}
