# nixos-dotfiles
NixOS Config with MangoWC and Dank Material Shell
<br>Specs:
<br>Wayland Compositor: [MangoWC](https://mangowc.vercel.app/)
<br>Desktop Shell: [Dank Material Shell](https://danklinux.com/)
<br>Text Editor: [Neovim](https://neovim.io/)
<br>Terminal: kitty
<br>File Manager: dolphin
<br> App Launcher: Rofi
## Neovim
- Neovim config files are symlinked to the `lua/` and `plugin/` directories so the Lua config stays portable and can be reused on any OS.

## Installation Instructions
```
git clone https://github.com/brandonboo2024/nixos-dotfiles
```
```
sudo nixos-rebuild switch --flake ~/nixos-dotfiles#<hostname>
```
## Dependencies
All dependencies are automatically managed by home-manager and nix package manager
<br> To add additional LSPs to your neovim configuration, you will need to add packages via home-manager instead of Mason.nvim

---

## Preview
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/659ce9e9-6f4c-4b46-a5bf-1a7efc3f0eb7" />
