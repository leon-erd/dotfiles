{
  pkgs,
  config,
  lib,
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

  ### load needed secrets ###
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

  ### mount main and backup drives ###
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

  ### CONFIGURE NEXTCLOUD ###
  services.nextcloud = {
    enable = true;

    ### package setup ###
    # remember you can only upgrade Nextcloud to the next major version
    # if you want to upgrade to a newer version, change the nextcloud package (and customcss package) here
    package = pkgs.nextcloud31;
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
    appstoreEnable = false;
    autoUpdateApps = {
      enable = true;
      startAt = "07:00:00";
    };

    ### main settings ###
    hostName = systemSettings.nextcloud.hostName;
    home = "/var/lib/nextcloud";
    datadir = mainDriveMountPoint;
    config = {
      dbuser = "nextcloud";
      dbtype = "mysql";
      dbname = "nextcloud";
      adminuser = "admin";
      adminpassFile = config.sops.secrets."nextcloud/adminpass".path;
    };
    database.createLocally = true;

    ### use Redis for all caching except local memcache ###
    caching = {
      apcu = true;
      redis = true;
    };
    configureRedis = true;

    ### config.php settings ###
    enableImagemagick = true;
    settings = {
      enabledPreviewProviders = [
        # default providers
        "OC\\Preview\\BMP"
        "OC\\Preview\\GIF"
        "OC\\Preview\\JPEG"
        "OC\\Preview\\Krita"
        "OC\\Preview\\MarkDown"
        "OC\\Preview\\MP3"
        "OC\\Preview\\OpenDocument"
        "OC\\Preview\\PNG"
        "OC\\Preview\\TXT"
        "OC\\Preview\\XBitmap"
        # additional providers
        "OC\\Preview\\HEIC"
      ];
      log_type = "file";
      maintenance_window_start = 2; # run non time-sensitive tasks at 2:00am for up to 4 hours
      trusted_domains = systemSettings.nextcloud.trusted_domains;
      overwriteprotocol = "https";
      preview_max_x = 2048;
      preview_max_y = 2048;
      jpeg_quality = 60;
    };

    ### php.ini settings ###
    phpOptions = {
      "opcache.interned_strings_buffer" = 16;
      # we allow uploads of up to 8GB (it seems that this is only neccessary for WebDAV uploads (e.g. FolderSync); large file uploads from the web interface or nextcloud client also work with low limits) but we do not want the PHP memory limit to be that high for low resource setups (the nixos module sets it to maxUploadSize by default)
      "memory_limit" = lib.mkForce "512M";
    };
    maxUploadSize = "8G";

    ### php-fpm.conf settings (reduce overhead for low resource setups) ###
    poolSettings = {
      pm = "ondemand";
      "pm.max_children" = 12;
      "pm.process_idle_timeout" = "1m";
      "pm.max_requests" = 500;
    };

    ### Use HTTPS for generated links ###
    https = true;

    ### notify push settings ###
    notify_push.enable = false;
  };

  ### CONFIGURE NGINX and ACME ###
  security.acme.acceptTerms = true;
  security.acme.defaults.email = systemSettings.acmeEmail;
  services.nginx.recommendedTlsSettings = true;
  services.nginx.recommendedOptimisation = true;
  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
  };

  ### open ports in firewall ###
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  ### CONFIGURE LOGROTATE ###
  services.logrotate.settings."${mainDriveMountPoint}/data/nextcloud.log" = {
    dateext = true;
    compress = false;
    missingok = true;
    notifempty = true;
    frequency = "weekly";
    rotate = 4;
    create = "0640 nextcloud nextcloud";
  };

  ### CONFIGURE SYSTEMD SERVICES AND TIMERS ###
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

  ### CONFIGURE FAIL2BAN ###
  # https://docs.nextcloud.com/server/latest/admin_manual/installation/harden_server.html#fail2ban-introduction
  environment.etc = {
    "fail2ban/filter.d/nextcloud.conf".text = ''
      [Definition]
      _groupsre = (?:(?:,?\s*"\w+":(?:"[^"]+"|\w+))*)
      failregex = ^\{%(_groupsre)s,?\s*"remoteAddr":"<HOST>"%(_groupsre)s,?\s*"message":"Login failed:
                  ^\{%(_groupsre)s,?\s*"remoteAddr":"<HOST>"%(_groupsre)s,?\s*"message":"Two-factor challenge failed:
                  ^\{%(_groupsre)s,?\s*"remoteAddr":"<HOST>"%(_groupsre)s,?\s*"message":"Trusted domain error.
      datepattern = ,?\s*"time"\s*:\s*"%%Y-%%m-%%d[T ]%%H:%%M:%%S(%%z)?"
    '';
  };
  services.fail2ban.jails = {
    nextcloud.settings = {
      backend = "auto";
      enabled = true;
      port = "80,443";
      protocol = "tcp";
      filter = "nextcloud";
      logpath = "${mainDriveMountPoint}/data/nextcloud.log";
    };
    nginx-bad-request.settings.enabled = true;
    nginx-botsearch.settings.enabled = true;
  };
}
