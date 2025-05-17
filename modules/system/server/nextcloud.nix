{
  pkgs,
  config,
  systemSettings,
  ...
}:

let
  mainDriveMountPoint = "/media/nextcloud/main_drive";
  backupDriveMountPoint = "/media/nextcloud/backup_drive";
in
{
  sops.secrets."nextcloud/adminpass" = {
    owner = "nextcloud";
  };

  fileSystems."${mainDriveMountPoint}" = {
    device = "/dev/disk/by-id/${systemSettings.nextcloudDrives.mainDrive}";
    options = [
      "defaults"
      "nofail"
    ];
  };
  fileSystems."${backupDriveMountPoint}" = {
    device = "/dev/disk/by-id/${systemSettings.nextcloudDrives.backupDrive}";
    options = [
      "defaults"
      "nofail"
    ];
  };

  services.nextcloud = {
    https = false;
    datadir = mainDriveMountPoint;
    settings = {
      log_type = "syslog";
      trusted_domains = [
        "10.10.10.100"
      ];
      # overwriteprotocol = "https";
    };
    phpOptions = { };
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps)
        calendar
        contacts
        notes
        previewgenerator
        tasks
        ;
    };
    caching = {
      apcu = true;
      redis = true;
    };
    configureRedis = true;
    config = {
      dbuser = "nextcloud";
      dbtype = "mysql";
      dbname = "nextcloud";
      adminuser = "admin";
      adminpassFile = config.sops.secrets."nextcloud/adminpass".path;
    };
    database.createLocally = true;
    appstoreEnable = false;
    autoUpdateApps = {
      enable = true;
      startAt = "07:00:00";
    };
    enableImagemagick = true;
    notify_push.enable = false;
    hostName = "amysweinhaus.ddnss.de";
    home = "/var/lib/nextcloud";
    package = pkgs.nextcloud31;
    enable = true;
  };

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "leonvincenterd@web.de";

  services.nginx.recommendedTlsSettings = true;
  services.nginx.recommendedOptimisation = true;
  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
  };
}
