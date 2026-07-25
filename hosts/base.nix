{ pkgs, ... }:

# Settings every machine gets. Anything that only some machines want belongs
# in a module under hosts/modules/ (imported by the hosts that want it) or in
# a profile under hosts/profiles/.
#
# networking.hostName is not set here: it is derived from the flake
# configuration name in flake.nix.
{
  imports = [
    ./modules/packages.nix
    ./modules/audio.nix
    ./modules/bluetooth.nix
    ./modules/bootloader.nix
    ./modules/fonts.nix
    ./modules/maintenance.nix
    ./modules/users.nix
  ];

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Security and keyrings.
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;

  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Asia/Singapore";

  environment = {
    # Where clangd should look for the glibc headers.
    etc."clangd/glibc/include".source = "${pkgs.stdenv.cc.libc.dev}/include";
    variables = {
      # emacsclient, not emacs: River starts an Emacs daemon, and a bare
      # `emacs` here would give every caller -- git, claude, codex -- a cold
      # instance with none of the daemon's state. -a emacs falls back to
      # starting one if no daemon is running.
      EDITOR = "emacsclient -nw -a emacs";
    };
  };

  # Not session-specific: whatever the desktop, sioyek opens PDFs. Its
  # Exec is `sioyek %f`, resolved through PATH, so this works whether or not
  # the machine installed the xcb-wrapped build (see home/modules/sioyek.nix).
  xdg.mime.defaultApplications = {
    "application/pdf" = [ "sioyek.desktop" ];
  };

  services.printing.enable = false;
  programs.nano.enable = false;

  # Off everywhere, as it always has been. Note this is not merely the
  # default: with Plasma installed, NixOS would otherwise switch it on.
  # hosts/modules/power.nix additionally requires it off, since auto-cpufreq
  # and power-profiles-daemon both drive the CPU governor.
  services.power-profiles-daemon.enable = false;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Declared here rather than only in the flake's nixConfig. nixConfig is a
    # client-specified setting, so the daemon honours it for trusted users
    # alone: as an ordinary user every `nix build` and `nix flake check` was
    # answered with "ignoring untrusted substituter" and built from source.
    # Set as a system setting these apply to every caller, root or not.
    substituters = [
      "https://nix-community.cachix.org"
      "https://claude-code.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk="
    ];

    # So a flake that brings its own nixConfig is honoured too, instead of
    # being silently dropped the way the two above were.
    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  # Hardlink identical files in the store. Scheduled rather than
  # nix.settings.auto-optimise-store, which hashes on every store write and
  # slows builds down; this does the same work once, off-peak.
  nix.optimise = {
    automatic = true;
    dates = [ "03:00" ];
  };

  system.stateVersion = "25.11"; # just dont touch this
}
