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

      pkgsStable = mkPkgs nixpkgs-stable;
      pkgs = mkPkgs nixpkgs;

      mkHost =
        {
          hostModule,
          username,
          homeModule,
          extraModule,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs pkgsStable;
          };
          modules = [
            {
              nixpkgs = {
                overlays = overlays;
                config.allowUnfree = true;
              };
            }

            hostModule
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = {
                  inherit inputs pkgsStable;
                };
                users.${username} = {
                  imports = [
                    homeModule
                  ];
                };
              };
            }
          ];
        };
    in
    {
      # `nix fmt` formats every tracked .nix file. nixfmt-tree is the treefmt
      # wrapper around nixfmt: unlike bare nixfmt it honours .gitignore, so it
      # will not descend into the nested config/ dotfiles repository.
      formatter.${system} = pkgs.nixfmt-tree;

      nixosConfigurations = {
        # ThinkPad laptop
        Daedalus = mkHost {
          hostModule = ./hosts/Daedalus/default.nix;
          username = "Daedalus";
          homeModule = ./home/Daedalus.nix;
          extraModule = [

          ];
        };

        # Yoga laptop
        Prometheus = mkHost {
          hostModule = ./hosts/Prometheus/default.nix;
          username = "Prometheus";
          homeModule = ./home/Prometheus.nix;
          extraModule = [

          ];
        };

        # Desktop
        Hephaestus = mkHost {
          hostModule = ./hosts/Hephaestus/default.nix;
          username = "Hephaestus";
          homeModule = ./home/Hephaestus.nix;
          extraModule = [

          ];
        };
      };
    };
}
