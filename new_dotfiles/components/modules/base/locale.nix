{ ... }:

{
  flake.modules.nixos.locale =
    { config, ... }:

    {
      console.keyMap = config.mySystemConfig.kblayout; # tty keyboard layout

      # set locales
      time.timeZone = config.mySystemConfig.timezone;
      i18n.defaultLocale = config.mySystemConfig.defaultLocale;
      i18n.extraLocaleSettings = {
        LC_ADDRESS = config.mySystemConfig.extraLocale;
        LC_IDENTIFICATION = config.mySystemConfig.extraLocale;
        LC_MEASUREMENT = config.mySystemConfig.extraLocale;
        LC_MONETARY = config.mySystemConfig.extraLocale;
        LC_NAME = config.mySystemConfig.extraLocale;
        LC_NUMERIC = config.mySystemConfig.extraLocale;
        LC_PAPER = config.mySystemConfig.extraLocale;
        LC_TELEPHONE = config.mySystemConfig.extraLocale;
        LC_TIME = config.mySystemConfig.extraLocale;
      };
    };
}
