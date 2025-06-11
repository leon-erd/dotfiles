{ systemSettings, ... }:

{
  sops = {
    age.keyFile = "/home/${systemSettings.users."1".username}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
  };
}
