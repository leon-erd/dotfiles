{ systemSettings, ... }:

{
  console.keyMap = systemSettings.kblayout; # tty keyboard layout

  # set locales
  time.timeZone = systemSettings.timezone;
  i18n.defaultLocale = systemSettings.defaultLocale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = systemSettings.extraLocale;
    LC_IDENTIFICATION = systemSettings.extraLocale;
    LC_MEASUREMENT = systemSettings.extraLocale;
    LC_MONETARY = systemSettings.extraLocale;
    LC_NAME = systemSettings.extraLocale;
    LC_NUMERIC = systemSettings.extraLocale;
    LC_PAPER = systemSettings.extraLocale;
    LC_TELEPHONE = systemSettings.extraLocale;
    LC_TIME = systemSettings.extraLocale;
  };
}
