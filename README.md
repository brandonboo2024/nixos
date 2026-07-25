# nixos

NixOS configuration for three machines, built from one flake.

Specs:
- **Compositor:** [River](https://codeberg.org/river/river) (`river-classic`)
- **Status bar:** [Creek](https://git.sr.ht/~novakane/creek)
- **Editor:** [Emacs](https://www.gnu.org/software/emacs/)
- **Terminal:** [Foot](https://codeberg.org/dnkl/foot)
- **File manager:** [Yazi](https://yazi-rs.github.io/)
- **App launcher:** [Fuzzel](https://codeberg.org/dnkl/fuzzel)
- **Notifications:** [Mako](https://github.com/emersion/mako)

## Hosts

| Flake configuration | Device   | Host module        | Home Manager module   |
| ------------------- | -------- | ------------------ | --------------------- |
| `Hephaestus`        | Desktop  | `hosts/Hephaestus` | `home/Hephaestus.nix` |
| `Prometheus`        | Yoga     | `hosts/Prometheus` | `home/Prometheus.nix` |
| `Daedalus`          | ThinkPad | `hosts/Daedalus`   | `home/Daedalus.nix`   |

The flake configuration name, `networking.hostName`, the Home Manager username,
and the home directory all agree for each host.

## Installation

Portable application configuration lives in a
[separate dotfiles repository](https://github.com/brandonboo2024/dotfiles) so it
stays usable on non-NixOS machines. Home Manager symlinks it out of the store
from `~/nixos/config`, so **both** repositories are required:

```sh
git clone https://github.com/brandonboo2024/nixos ~/nixos
git clone https://github.com/brandonboo2024/dotfiles ~/nixos/config
sudo nixos-rebuild switch --flake ~/nixos#<hostname>
```

Without the second clone every `~/.config` symlink dangles.

Three flake inputs are personal and are referenced unconditionally, so
dropping one means removing its use as well, not just the input:

| input | used by |
| --- | --- |
| `assets` | `hosts/modules/fonts.nix` (Berkeley Mono) |
| `pi_flake` | `home/modules/packages.nix` |
| `codex` | `home/modules/packages.nix` |

## Layout

```
flake.nix          inputs, overlays, host wiring
hosts/base.nix     settings shared by every machine
hosts/modules/     opt-in system modules
hosts/<Host>/      hardware and machine-specific settings
home/base.nix      shared Home Manager configuration
home/modules/      per-application Home Manager modules
home/<Host>.nix    per-machine Home Manager settings
walls/             wallpapers
config/            dotfiles repository (nested, not tracked here)
```

## Working on this repository

```sh
nix fmt                                   # format all .nix files
nix flake check --no-build                # flake-level validation
nix build --no-link .#nixosConfigurations.<host>.config.system.build.toplevel
```

## Dependencies

All dependencies are managed declaratively by Nix and Home Manager. Additional
language servers belong in `home/modules/dev.nix` rather than in an
editor-specific package manager.

---

## Preview

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/659ce9e9-6f4c-4b46-a5bf-1a7efc3f0eb7" />
