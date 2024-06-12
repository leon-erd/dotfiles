# dotfiles

Just my personal dotfiles :)

## Install instructions

To get this running on a NixOS system, start by going into a shell with `git` installed:
```bash
nix-shell -p git
```

Then clone the repo:
```bash
git clone https://github.com/leon-erd/dotfiles.git ~/dotfiles
```

To get the hardware configuration on a new system, either copy from `/etc/nixos/hardware-configuration.nix` or run:
```bash
cd ~/dotfiles
sudo nixos-generate-config --show-hardware-config > hosts/<host>/hardware-configuration.nix
```

Make sure to update the `systemSettings` and `userSettings` in `hosts/<host>/flakeConfiguration.nix` to your needs:
```nix
...
let
  systemSettings = {
    hostname = "leon-inspiron";
    timezone = "Europe/Vienna";
    defaultLocale = "en_US.UTF-8";
...
```

Once the variables are set, switch into the system configuration by running:
```bash
cd ~/dotfiles
sudo nixos-rebuild switch --flake ./#<systemConfigurationName>
```
where `systemConfigurationName` corresponds to the value set in `hosts/<host>/flakeConfiguration.nix`.

The home-manager configuration can be installed with (might need to logout/login once before):
```bash
cd ~/dotfiles
home-manager switch --flake ./#<userConfigurationName>
```
