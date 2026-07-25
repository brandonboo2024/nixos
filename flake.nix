{
  description = "Minimal NixOS with River-classic and KDE";
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
      nixosConfigurations = {
        Daedalus = mkHost {
          hostModule = ./hosts/thinkpad/default.nix;
          username = "Daedalus";
          homeModule = ./home/boo/thinkpad.nix;
          extraModule = [

          ];
        };

        Prometheus = mkHost {
          hostModule = ./hosts/yoga/default.nix;
          username = "Prometheus";
          homeModule = ./home/boo/yoga.nix;
          extraModule = [

          ];
        };

        Hephaestus = mkHost {
          hostModule = ./hosts/desktop_1/default.nix;
          username = "Hephaestus";
          homeModule = ./home/boo/desktop_1.nix;
          extraModule = [

          ];
        };
      };
    };
}
