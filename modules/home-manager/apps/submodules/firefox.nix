{ pkgs, userSettings, ...}:

{
  programs.firefox = {
    enable = true;
    profiles.${userSettings.username} = {
      search = {
        default = "ddg"; # DuckDuckGo
        force = true;
      };
      settings = {
        "browser.startup.page" = 3; # resume previous session
        "signon.rememberSignons" = false; # don't ask to save passwords
        "extensions.activeThemeID" = "firefox-compact-light@mozilla.org"; # light theme
        "extensions.autoDisableScopes" = 0; # automatically enable extensions installed with home-manager
        "browser.toolbars.bookmarks.visibility" = "always"; # toolbar always visible
        "browser.download.always_ask_before_handling_new_types" = true; # ask whether to "open" or to "save"
        "browser.download.start_downloads_in_tmp_dir" = true; # if "open" selected: save in tmp dir
        "browser.download.useDownloadDir" = false; # if "save" selected: ask where to save
        # Privacy
        "app.shield.optoutstudies.enabled" = false;
        "privacy.donottrackheader.enabled" = true;
        "privacy.globalprivacycontrol.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "dom.private-attribution.submission.enabled" =false;
        "datareporting.healthreport.uploadEnabled" = false;
      };
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        betterttv
        bitwarden
        duckduckgo-privacy-essentials
        grammarly
        ublock-origin
        videospeed
        vimium-c
      ];
      bookmarks = {
        force = true;
        settings = [
          {
            toolbar = true;
            bookmarks = [
              {name = "Fast.com";
              url = "https://fast.com";}
              {name = "Amy's Weinhaus";
              url = "https://10.10.10.100";}
              {name = "Pihole";
              url = "http://10.10.10.100:8080/admin/";}
              {name = "Github";
              url = "https://github.com/";}
              {name = "Twitch";
              url = "https://twitch.tv/directory/following";}
              {name = "Youtube";
              url = "https://youtube.com";}
              {name = "ChatGPT";
              url = "https://chat.openai.com";}
              {name = "Python print cheat sheet";
              url = "https://learnpython.com/blog/python-string-formatting/";}
              {name = "Noogle";
              url = "https://noogle.dev/";}
            ];
          }
        ];
      };
    };
  };

  home.sessionVariables = {
    MOZ_USE_XINPUT2 = 1; # better touch support
  };
}

