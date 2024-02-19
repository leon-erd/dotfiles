# dotfiles

Just my personal dotfiles :)

## Install instructions

To get this running on a NixOS system, start by cloning the repo:
```bash
git clone https://github.com/leon-erd/dotfiles.git ~/dotfiles
```

To get the hardware configuration on a new system, either copy from `/etc/nixos/hardware-configuration.nix` or run:
```bash
cd ~/dotfiles
sudo nixos-generate-config --show-hardware-config > hosts/<host>/hardware-configuration.nix
```

Make sure to update the systemSettings and userSettings at the top of the flake.nix to your needs:
```nix
...
let
# ---- SYSTEM SETTINGS ---- #
systemSettings = {
    system = "x86_64-linux";
    hostname = "leon-inspiron";
    host = "inspiron-laptop";
...
```

Once the variables are set, then switch into the system configuration by running:
```nix
cd ~/dotfiles
sudo nixos-rebuild switch --flake .#system
```

The home-manager configuration can be installed with:
```nix
cd ~/.dotfiles
home-manager switch --flake .#user
```
