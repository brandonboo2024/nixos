{
  description = "Modular NixOS Configuration with MangoWC and DMS";
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
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
  };
  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nixpkgs-stable,
      mango,
      dankMaterialShell,
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

      pkgsStable = mkPkgs nixpkgs-stable;
      pkgs = mkPkgs nixpkgs;
      themes = import ./home/themes.nix { inherit inputs pkgs; };

      mkHost =
        {
          hostModule,
          username,
          homeModule,
          themeName,
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
            mango.nixosModules.mango
            dankMaterialShell.nixosModules.greeter
            {
              programs.mango.enable = true;

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = {
                  inherit inputs pkgsStable;
                  theme = themes.${themeName};
                };
                users.${username} = {
                  imports = [
                    homeModule
                    mango.hmModules.mango
                    inputs.dankMaterialShell.homeModules.dank-material-shell
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
          themeName = "thinkpad";
          extraModule = [

          ];
        };

        Prometheus = mkHost {
          hostModule = ./hosts/yoga/default.nix;
          username = "Prometheus";
          homeModule = ./home/boo/yoga.nix;
          themeName = "yoga";
          extraModule = [

          ];
        };

        Hephaestus = mkHost {
          hostModule = ./hosts/desktop_1/default.nix;
          username = "Hephaestus";
          homeModule = ./home/boo/desktop_1.nix;
          themeName = "desktop_1";
          extraModule = [

          ];
        };
      };
    };
}
