# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  inputs,
  config,
  lib,
  pkgs,
  pkgsStable,
  ...
}:

{
  imports = [
    #include common baselevel packages
    ./SystemModules/packages.nix
    ./SystemModules/bootloader.nix
    ./SystemModules/greeter.nix
    ./SystemModules/bluetooth.nix
    ./SystemModules/maintenance.nix
    # ./SystemModules/wireshark.nix
  ];
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "river";
  };

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # security and keyrings
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;

  services.power-profiles-daemon.enable = false;
  services.thermald.enable = true;
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };
  # allow proprietary software
  nixpkgs.config.allowUnfree = true;
  # Set your time zone.
  time.timeZone = "Asia/Singapore";

  # bios updater
  # services.fwupd.enable = true;
  programs.river-classic = {
    enable = true;
    xwayland.enable = true;
  };

  # setting wayland display for swayidle to recognise
  environment = {
    # setting clangd source
    etc."clangd/glibc/include".source = "${pkgs.stdenv.cc.libc.dev}/include";
    # setting session variables
    sessionVariables = {
    };
    # setting environment variables
    variables = {
      EDITOR = "emacs";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound.
  services.pulseaudio.enable = false;
  services.pipewire = {
    # enable support and different compatabilities
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.Daedalus = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };
  users.users.Prometheus = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "wireshark"
      "docker"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };
  users.users.Hephaestus = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "wireshark"
      "docker"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };
  programs.nano.enable = false;
  # programs.firefox.enable = true;
  # programs.neovim = {
  #   enable = true;
  #   defaultEditor = true;
  #   viAlias = true;
  #   vimAlias = true;
  # };
  fonts.packages = with pkgs; [
    inputs.assets.packages.${pkgs.stdenv.hostPlatform.system}.default
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    noto-fonts-color-emoji
  ];
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [
        "Berkeley Mono"
        "Symbols Nerd Font Mono"
        "JetBrainsMono Nerd Font"
      ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  xdg.mime.defaultApplications = {
    "application/pdf" = [
      "sioyek-x11.desktop"
      "org.pwmt.zathura-pdf-mupdf.desktop"
    ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "25.11"; # just dont touch this
}
