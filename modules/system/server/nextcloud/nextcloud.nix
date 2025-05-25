{
  pkgs,
  config,
  systemSettings,
  ...
}:

let
  mainDriveMountPoint = "/media/nextcloud/main_drive";
  backupDriveMountPoint = "/media/nextcloud/backup_drive";
  myCloudScripts =
    with pkgs.python3Packages;
    buildPythonPackage {
      name = "my-cloud-scripts";
      src = ./.;
      propagatedBuildInputs = [ requests ];
    };
in
{
  environment.systemPackages = with pkgs; [
    myCloudScripts
    borgbackup
  ];

  sops.secrets = {
    "nextcloud/adminpass" = {
      owner = "nextcloud";
    };
    "telegram/api_key" = {
      owner = "nextcloud";
    };
    "telegram/main_chat_id" = {
      owner = "nextcloud";
    };
  };

  fileSystems."${mainDriveMountPoint}" = {
    device = "/dev/disk/by-id/${systemSettings.nextcloudDrives.mainDrive}";
    fsType = "ext4";
    options = [
      # "defaults"
      "nofail"
      "x-systemd.automount"
    ];
  };
  fileSystems."${backupDriveMountPoint}" = {
    device = "/dev/disk/by-id/${systemSettings.nextcloudDrives.backupDrive}";
    fsType = "ext4";
    options = [
      # "defaults"
      "nofail"
      "x-systemd.automount"
      "x-systemd.idle-timeout=10min"
    ];
  };

  services.nextcloud = {
    https = true;
    datadir = mainDriveMountPoint;
    settings = {
      log_type = "syslog";
      trusted_domains = [
        "10.10.10.100"
      ];
      overwriteprotocol = "https";
      maintenance_window_start = 3; # run non time-sensitive tasks at 3:00am for up to 4 hours
    };
    phpOptions = {
      "opcache.interned_strings_buffer" = 16;
    };
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps)
        calendar
        contacts
        notes
        previewgenerator
        tasks
        ;
      theming_customcss = pkgs.fetchNextcloudApp {
        url = "https://github.com/nextcloud/theming_customcss/archive/refs/tags/v1.18.0.tar.gz";
        sha256 = "sha256-HfUHvT9O5vo+pm7Qwr0ZwXKTbe2K/KFeAtp/K92oqR8=";
        license = "agpl3Plus";
      };
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

  systemd.timers."nextcloud-preview-generator" = {
    wantedBy = [ "timers.target" ];
    after = [ "nextcloud-setup.service" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  systemd.services."nextcloud-preview-generator" = {
    after = [ "nextcloud-setup.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/nextcloud-occ preview:pre-generate";
      User = "nextcloud";
    };
  };
}
