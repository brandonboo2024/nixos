{ ... }:

# Settings every machine gets. Per-machine opt-ins go in hosts/modules/ or
# hosts/profiles/. networking.hostName is set by flake.nix.
{
  imports = [
    ./modules/packages.nix
    ./modules/audio.nix
    ./modules/bluetooth.nix
    ./modules/bootloader.nix
    ./modules/btrfs.nix
    ./modules/fonts.nix
    ./modules/kernel.nix
    ./modules/maintenance.nix
    ./modules/users.nix
  ];

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Security and keyrings.
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;

  time.timeZone = "Asia/Singapore";

  environment = {
    variables = {
      # Reuse the Emacs daemon River starts; fall back to a plain emacs if
      # none is running.
      EDITOR = "emacsclient -nw -a emacs";
    };
  };

  documentation.man.generateCaches = true;

  # Default handlers for PDFs and the image and video formats used by Yazi.
  xdg.mime.defaultApplications = {
    "application/pdf" = [ "sioyek.desktop" ];
    "image/png" = [ "imv.desktop" ];
    "image/jpeg" = [ "imv.desktop" ];
    "video/mp4" = [ "mpv.desktop" ];
    "video/x-matroska" = [ "mpv.desktop" ];
  };

  # Compressed swap in RAM, used before the disk swap partition (which stays
  # as overflow and hibernate target).
  zramSwap.enable = true;

  # Nix builds in /nix/var/nix/builds, not /tmp, so large builds do not
  # consume this RAM-backed space.
  boot.tmp.useTmpfs = true;

  services.printing.enable = false;
  programs.nano.enable = false;

  # Plasma (Hephaestus) would enable it, and it conflicts with auto-cpufreq
  # on the laptops (hosts/modules/power.nix).
  services.power-profiles-daemon.enable = false;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # The flake's nixConfig only applies to trusted users; setting the caches
    # here applies them to everyone. Keep in sync with nixConfig in flake.nix.
    substituters = [
      "https://nix-community.cachix.org"
      "https://cache.numtide.com"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];

    # Lets wheel users accept a flake's own nixConfig.
    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  # Builds only get CPU time the desktop is not using. The matching I/O class
  # needs the BFQ scheduler, and the NVMe drives use none, so it is not set.
  nix.daemonCPUSchedPolicy = "idle";

  # Dedupe the store off-peak instead of on every write
  # (auto-optimise-store), which slows builds.
  nix.optimise = {
    automatic = true;
    dates = [ "03:00" ];
  };

  # Set at install time; never change it on an existing machine.
  system.stateVersion = "25.11";
}
