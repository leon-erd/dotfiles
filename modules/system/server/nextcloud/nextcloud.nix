{
  pkgs,
  config,
  systemSettings,
  ...
}:

# IMPORTANT:
# When updating the Nextcloud package, also update the preview generator app

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
    device = "/dev/disk/by-id/${systemSettings.nextcloud.drives.main}";
    fsType = "ext4";
    options = [
      # "defaults"
      "nofail"
      "x-systemd.automount"
    ];
  };
  fileSystems."${backupDriveMountPoint}" = {
    device = "/dev/disk/by-id/${systemSettings.nextcloud.drives.backup}";
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
      log_type = "file";
      trusted_domains = systemSettings.nextcloud.trusted_domains;
      overwriteprotocol = "https";
      maintenance_window_start = 2; # run non time-sensitive tasks at 2:00am for up to 4 hours
      preview_max_x = 2048;
      preview_max_y = 2048;
      jpeg_quality = 60;
    };
    phpOptions = {
      "opcache.interned_strings_buffer" = 16;
    };
    # PHP-FPM settings (reduce overhead for small installations)
    poolSettings = {
      pm = "ondemand";
      "pm.max_children" = 12;
      "pm.process_idle_timeout" = "1m";
      "pm.max_requests" = 500;
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
    hostName = systemSettings.nextcloud.hostName;
    home = "/var/lib/nextcloud";
    package = pkgs.nextcloud31;
    enable = true;
  };

  security.acme.acceptTerms = true;
  security.acme.defaults.email = systemSettings.acmeEmail;

  services.nginx.recommendedTlsSettings = true;
  services.nginx.recommendedOptimisation = true;
  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  systemd.timers."nextcloud-preview-generator" = {
    wantedBy = [ "timers.target" ];
    after = [ "nextcloud-setup.service" ];
    timerConfig = {
      OnCalendar = "*-*-* 00:00:00";
      Persistent = true;
    };
  };
  systemd.services."nextcloud-preview-generator" = {
    after = [ "nextcloud-setup.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/my_nextcloud_preview_generator";
      User = "nextcloud";
    };
  };

  systemd.timers."nextcloud-cloudbackup" = {
    wantedBy = [ "timers.target" ];
    after = [ "nextcloud-setup.service" ];
    timerConfig = {
      OnCalendar = "*-*-* 04:00:00";
      Persistent = true;
    };
  };
  systemd.services."nextcloud-cloudbackup" = {
    after = [ "nextcloud-setup.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/my_nextcloud_cloudbackup";
      User = "nextcloud";
    };
  };

  systemd.timers."nextcloud-scheduled-reboot" = {
    wantedBy = [ "timers.target" ];
    after = [ "nextcloud-setup.service" ];
    timerConfig = {
      OnCalendar = "Mon *-*-* 12:00:00";
    };
  };
  systemd.services."nextcloud-scheduled-reboot" = {
    after = [ "nextcloud-setup.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/reboot";
    };
  };

  services.logrotate.settings."${mainDriveMountPoint}/data/nextcloud.log" = {
    dateext = true;
    compress = false;
    missingok = true;
    notifempty = true;
    frequency = "weekly";
    rotate = 4;
    create = "0640 nextcloud nextcloud";
  };
}
