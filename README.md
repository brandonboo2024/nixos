# nixos-dotfiles
NixOS Config with MangoWC and Dank Material Shell
<br>Specs:
<br>Wayland Compositor: [MangoWC](https://mangowc.vercel.app/)
<br>Desktop Shell: [Dank Material Shell](https://danklinux.com/)
<br>Text Editor: [Neovim](https://neovim.io/)
<br>Terminal: kitty
<br>File Manager: [Yazi](https://yazi-rs.github.io/docs/installation/)
<br>App Launcher: [bemenu](https://github.com/Cloudef/bemenu)

I have a separate [dotfiles](https://github.com/brandonboo2024/dotfiles) that I manage for more important tools so its more portable on non-NixOS devices.

## Installation Instructions
```
git clone https://github.com/brandonboo2024/nixos
```

```
sudo nixos-rebuild switch --flake ~/nixos-dotfiles#<hostname>
```

I have multiple flakes that I created for fun that is inside, you may look to remove them if you do not want them/

## Dependencies
All dependencies are automatically managed by home-manager and nix package manager
<br> To add additional LSPs to your neovim configuration, you will need to add packages via home-manager instead of Mason.nvim

---

## Preview
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/659ce9e9-6f4c-4b46-a5bf-1a7efc3f0eb7" />
