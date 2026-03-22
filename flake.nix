{
  description = "NixOS and macOS system configuration";

  inputs = {
    # home-manager module for user environment management
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # microvm.nix for lightweight NixOS VMs on macOS
    microvm.url = "github:astro/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";

    # nix-darwin module for macOS system configuration
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # sops-nix module to handle encrypted secrets
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      home-manager,
      microvm,
      nix-darwin,
      nixpkgs,
      sops-nix,
      ...
    }:
    let
      lib = nixpkgs.lib;

      # Helper to generate attributes for each system
      forAllSystems = lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
      ];

      mkMicroVM = import ./lib/mk-microvm.nix { inherit home-manager microvm nixpkgs; };
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShellNoCC {
            name = "dotfiles";
            packages =
              lib.optionals pkgs.stdenv.isDarwin [
                nix-darwin.packages.${system}.darwin-rebuild
                (pkgs.writeShellApplication {
                  name = "switch";
                  text = "sudo darwin-rebuild switch --flake '.#macos-aarch64'";
                })
              ]
              ++ lib.optionals pkgs.stdenv.isLinux [
                (pkgs.writeShellApplication {
                  name = "switch";
                  text = "NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --sudo --flake '.#vm-aarch64'";
                })
              ];
          };
        }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);

      #--------------------------------------------------------------------
      # System configurations (macOS + VMware VM)
      #--------------------------------------------------------------------

      darwinConfigurations.macos-aarch64 = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit home-manager sops-nix; };
        modules = [
          ./machines/macos-aarch64.nix
        ];
      };

      nixosConfigurations.vm-aarch64 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit home-manager sops-nix; };
        modules = [
          ./machines/vm-aarch64.nix
        ];
      };

      #--------------------------------------------------------------------
      # MicroVMs (aarch64-linux guests, launched via vfkit)
      #--------------------------------------------------------------------

      nixosConfigurations.dotfiles-vm = mkMicroVM "dotfiles";

      packages.aarch64-darwin.dotfiles-vm =
        self.nixosConfigurations.dotfiles-vm.config.microvm.declaredRunner;
    };
}
