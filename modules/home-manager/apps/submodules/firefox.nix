{ pkgs, userSettings, ... }:

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
        "dom.private-attribution.submission.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
      };
      extensions = {
        force = true;
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          betterttv
          bitwarden
          duckduckgo-privacy-essentials
          grammarly
          ublock-origin
          videospeed
          vimium-c
        ];
        # to find the settings in firefox:
        # 1. make desired changes to the extension
        # 2. go to
        # about:debugging#/runtime/this-firefox
        # 3. find the Extension ID and inspect the extension
        # 4. try the following commands in the console:
        # await browser.storage.sync.get(null);
        # await browser.storage.local.get(null);
        settings = {
          "vimium-c@gdh1995.cn" = {
            settings = {
              exclusionRules = [
                {
                  passKeys = "";
                  pattern = "^https?://[^/]*twitch.tv/";
                }
                {
                  passKeys = "";
                  pattern = "^https?://[^/]*kick.com/";
                }
                {
                  passKeys = "";
                  pattern = "^https?://[^/]*youtube.com/watch";
                }
              ];
            };
          };
          "uBlock0@raymondhill.net" = {
            settings = {
              # https://raw.githubusercontent.com/pixeltris/TwitchAdSolutions/master/video-swap-new/video-swap-new-ublock-origin.js
              #
              # If block doesn't work, try manually unsetting userResourcesLocation and setting it back to the URL
              "user-filters" = "twitch.tv##+js(twitch-videoad)";
              hiddenSettings = {
                userResourcesLocation = "https://raw.githubusercontent.com/pixeltris/TwitchAdSolutions/master/video-swap-new/video-swap-new-ublock-origin.js";
              };
            };
          };
        };
      };
      bookmarks = {
        force = true;
        settings = [
          {
            toolbar = true;
            bookmarks = [
              {
                name = "Fast.com";
                url = "https://fast.com";
              }
              {
                name = "Amy's Weinhaus";
                url = "https://amysweinhaus.ddnss.de";
              }
              {
                name = "Pihole";
                url = "https://pi.hole:8443";
              }
              {
                name = "Github";
                url = "https://github.com/";
              }
              {
                name = "Twitch";
                url = "https://twitch.tv/directory/following";
              }
              {
                name = "Youtube";
                url = "https://youtube.com";
              }
              {
                name = "ChatGPT";
                url = "https://chat.openai.com";
              }
              {
                name = "T3 Chat";
                url = "https://t3.chat/";
              }
              {
                name = "Noogle";
                url = "https://noogle.dev/";
              }
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
