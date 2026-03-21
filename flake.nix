{
  description = "NixOS and macOS system configuration";

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # nix-darwin module for macOS system configuration
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # home-manager module for user environment management
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # sops-nix module to handle encrypted secrets
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      sops-nix,
      ...
    }:
    let
      # Helper to generate attributes for each system
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "aarch64-darwin"
      ];
    in
    {
      # Formatter configuration for `nix fmt`
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShellNoCC {
            name = "dotfiles";
            packages =
              if pkgs.stdenv.isDarwin then
                [
                  nix-darwin.packages.${system}.darwin-rebuild
                  (pkgs.writeShellApplication {
                    name = "switch";
                    text = ''
                      echo "> Running darwin-rebuild switch..."
                      sudo darwin-rebuild switch --flake ".#macos-aarch64"
                      echo "> darwin-rebuild switch was successful ✅"
                    '';
                  })
                ]
              else
                [
                  (pkgs.writeShellApplication {
                    name = "switch";
                    text = ''
                      echo "> Running nixos-rebuild switch..."
                      NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --sudo --flake ".#vm-aarch64"
                      echo "> nixos-rebuild switch was successful ✅"
                    '';
                  })
                  (pkgs.writeShellApplication {
                    name = "try";
                    text = ''
                      echo "> Running nixos-rebuild test..."
                      NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild test --sudo --flake ".#vm-aarch64"
                      echo "> nixos-rebuild test was successful ✅"
                    '';
                  })
                ];
          };
        }
      );

      # NixOS VM configuration
      nixosConfigurations.vm-aarch64 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit home-manager sops-nix; };
        modules = [
          ./machines/vm-aarch64.nix
        ];
      };

      # macOS configuration
      darwinConfigurations.macos-aarch64 = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit home-manager sops-nix; };
        modules = [
          ./machines/macos-aarch64.nix
        ];
      };
    };
}
