{ pkgs, userSettings, ...}:

{
  programs.firefox = {
    enable = true;
    profiles.${userSettings.username} = {
      search = {
        default = "DuckDuckGo";
        force = true;
      };
      settings = {
        "browser.startup.page" = 3;
        "signon.rememberSignons" = false;
        "extensions.activeThemeID" = "firefox-compact-light@mozilla.org";
        "extensions.autoDisableScopes" = 0;
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.download.always_ask_before_handling_new_types" = true;
        "browser.download.start_downloads_in_tmp_dir" = true;
        "browser.download.useDownloadDir" = false;
      };
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        betterttv
        bitwarden
        duckduckgo-privacy-essentials
        grammarly
        ublock-origin
        videospeed
        vimium-c
      ];
      bookmarks = [
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
          ];
        }
      ];
    };
  };

  home.sessionVariables = {
    MOZ_USE_XINPUT2 = 1;
  };
}

