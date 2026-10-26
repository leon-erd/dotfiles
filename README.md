# dotfiles

My personal nix configurations designed with focus on usability, aesthetics and productivity :) \
Includes configurations for desktop NixOS, server NixOS, nix-darwin, and home-manager following the [dendritic pattern](https://discourse.nixos.org/t/the-dendritic-pattern/61271) using [flake-parts](https://github.com/hercules-ci/flake-parts) + [import-tree](https://github.com/vic/import-tree).

## Secrets

Secrets are managed with [sops-nix](https://github.com/Mic92/sops-nix). The AGE key must be present at `~/.config/sops/age/keys.txt` before activating any configuration that uses secrets.

## Installation

**1. Bootstrap NixOS and clone:**
```bash
nix-shell -p git
git clone https://github.com/leon-erd/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

**2. Copy AGE key** (if configuration needs secrets):
```bash
mkdir -p ~/.config/sops/age
cp /path/to/keys.txt ~/.config/sops/age/keys.txt
```

**3. Generate hardware config** (if new machine):
```bash
cd ~/dotfiles
sudo nixos-generate-config --show-hardware-config \
  > components/hosts/<host>/_hardware-configuration.nix
```

**4. Build system configuration:**
```bash
cd ~/dotfiles
sudo nixos-rebuild switch --flake ./#<systemConfigurationName>
```

**5. Build home configuration** (might need logout/login once):
```bash
cd ~/dotfiles
home-manager switch --flake ./#<userConfigurationName>
```

### Local commit checks

Enable the repository's pre-commit hook once after cloning:

```bash
git config --local core.hooksPath .githooks
```

## Architecture

`import-tree` auto-imports `.nix` files under `components/` into the flake. The Raspberry Pi and Esprimo host directories are excluded because they use separate flakes. No manual registration needed when adding new modules.\
Modules are namespaced by flake-parts module class and accessed via `self.modules.<class>.<name>`:

| Class | Used for |
|-------|---------|
| `nixos` | NixOS system modules |
| `homeManager` | Home Manager modules |
| `darwin` | nix-darwin system modules |
| `generic` | host-specific configs (usable in any namespace) |
| `system` | cross-platform modules for the use in NixOS and Darwin |

### `resolveSystemModules`

`system`-class modules can't be passed directly to `nixosSystem`/`darwinSystem` (wrong `_class`).\
`self.lib.resolveSystemModules` maps over a module list and converts `system` → target class

### pkgs via `perSystem` / `withSystem`

`nixpkgs` is instantiated once in `perSystem` (with overlays, `allowUnfree`, etc.). The hosts consume the appropriate pkgs set via `withSystem` in their system and home-manager configs — ensuring consistent `nixpkgs` across multiple hosts.

### Hosts

Each host lives in `components/hosts/<hostname>/` and consists of:

| File | Purpose |
|------|---------|
| `_settings-base.nix` | Pure attrset for top-level settings |
| `settings.nix` | Flake module: exposes `nixos.host<Name>SystemConfig` + `generic.host<Name>UserConfig` |
| `default.nix` | Wires `nixosConfigurations` / `homeConfigurations` together |
| `_hardware-configuration.nix` | Machine-specific hardware config |
| `extra-config.nix` | Optional host-specific overrides |
