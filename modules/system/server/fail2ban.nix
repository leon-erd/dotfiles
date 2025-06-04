{ ... }:

{
  services.fail2ban = {
    enable = true;
    ignoreIP = [ ];
    bantime = "10m";
    maxretry = 5;
    bantime-increment = {
      enable = true;
      maxtime = "168h";
    };
    # defaults that cannot be set as module options go here (module options are transformed to DEFAULT.settings options)
    jails.DEFAULT.settings = {
      findtime = "10m";
      dbpurgeage = "30d";
    };
  };
}
