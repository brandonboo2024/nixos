{
  description = "Minimal NixOS with River and Emacs";
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://claude-code.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk="
    ];
  };
  inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-25.11";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    assets = {
      url = "git+ssh://git@github.com/brandonboo2024/assets";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pi_flake = {
      url = "github:brandonboo2024/pi_flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    codex = {
      url = "github:sadjow/codex-cli-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nixpkgs-stable,
      ...
    }:
    let
      system = "x86_64-linux";
      overlays = [
        inputs.emacs-overlay.overlays.default
        inputs.claude.overlays.default
      ];

      mkPkgs =
        nixpkgsInput:
        import nixpkgsInput {
          inherit system overlays;
          config.allowUnfree = true;
        };

      # Passed to every system and Home Manager module through specialArgs, so
      # any module can substitute a single package from stable without the
      # whole machine moving off unstable. A module opts in just by naming
      # pkgsStable in its argument set; home/profiles/river.nix does this for
      # creek, whose zig-wayland scanner does not build against unstable's
      # wayland 1.26. Keeping the escape hatch is the point: this is the cheap
      # way out when one package breaks on unstable.
      pkgsStable = mkPkgs nixpkgs-stable;
      pkgs = mkPkgs nixpkgs;

      # Every machine is identified by one name, used as the flake
      # configuration name, the hostname, the Home Manager username and the
      # home directory. Everything below is derived from it, so there is
      # nothing to keep in agreement by hand: to add a machine, create
      # hosts/<Name>/ and home/<Name>.nix and add it to `hosts` below.
      mkHost =
        hostName:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs pkgsStable hostName;
          };
          modules = [
            {
              nixpkgs = {
                overlays = overlays;
                config.allowUnfree = true;
              };
              networking.hostName = hostName;
            }

            ./hosts/${hostName}
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = {
                  inherit inputs pkgsStable hostName;
                };
                users.${hostName} = {
                  imports = [ ./home/${hostName}.nix ];
                  home.username = hostName;
                  home.homeDirectory = "/home/${hostName}";
                };
              };
            }
          ];
        };

      # Which device each name is on is in the README's host table, which is
      # where someone looks for it. Recording it here as well only gave a
      # value that mapAttrs then had to discard.
      hosts = [
        "Hephaestus"
        "Prometheus"
        "Daedalus"
      ];
    in
    {
      # `nix fmt` formats every tracked .nix file. nixfmt-tree is the treefmt
      # wrapper around nixfmt: unlike bare nixfmt it honours .gitignore, so it
      # will not descend into the nested config/ dotfiles repository.
      formatter.${system} = pkgs.nixfmt-tree;

      nixosConfigurations = nixpkgs.lib.genAttrs hosts mkHost;
    };
}
