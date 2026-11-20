{
  description = "Minimal NixOS with River and Emacs";

  # Also set in hosts/base.nix; keep the two lists in sync by hand. This copy
  # lets the first `nixos-install --flake` hit the caches before base.nix is on
  # disk. nixConfig must be a literal, so it cannot share a binding with it.
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.numtide.com"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };
  inputs = {
    # Pinned so kernel bumps are deliberate and tested on hardware (see
    # hosts/Prometheus/sound.nix). Bump it to the current `nixpkgs` rev: the
    # NixOS module tooling assumes the kernel's build layout, and a stale pin
    # breaks the build (Linux 7.1 lacked the modules.cer that newer tooling
    # copies).
    nixpkgs-kernel.url = "github:NixOS/nixpkgs/04906337b6d53e8bb0eaf0470ae9f070a4d4eb55";
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
    # Coding-agent CLIs. Its nixpkgs is not followed, so builds match what
    # cache.numtide.com serves.
    llm-agents.url = "github:numtide/llm-agents.nix";
  };
  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nixpkgs-kernel,
      nixpkgs-stable,
      ...
    }:
    let
      system = "x86_64-linux";
      overlays = [
        inputs.emacs-overlay.overlays.default
      ];

      mkPkgs =
        nixpkgsInput:
        import nixpkgsInput {
          inherit system overlays;
          config.allowUnfree = true;
        };

      # Escape hatch for single packages that break on unstable: any module
      # can take `pkgsStable` as an argument (e.g. creek in
      # home/profiles/river.nix).
      pkgsStable = mkPkgs nixpkgs-stable;
      # No overlays, so the kernel and its out-of-tree modules match the cache
      # for the pinned revision.
      pkgsKernel = import nixpkgs-kernel {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs = mkPkgs nixpkgs;

      # One name per machine: flake output, hostname, username and home
      # directory. To add a machine, create hosts/<Name>/ and home/<Name>.nix
      # and list it in `hosts`.
      mkHost =
        hostName:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              inputs
              pkgsKernel
              pkgsStable
              hostName
              ;
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

      # The README's host table maps each name to its device.
      hosts = [
        "Hephaestus"
        "Prometheus"
        "Daedalus"
      ];
    in
    {
      # nixfmt-tree honours .gitignore, so `nix fmt` skips the nested config/.
      formatter.${system} = pkgs.nixfmt-tree;

      nixosConfigurations = nixpkgs.lib.genAttrs hosts mkHost;
    };
}
