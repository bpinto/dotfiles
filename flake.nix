{
  description = "NixOS VM configuration for development";

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # home-manager module for user environment management
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # sops-nix module to handle encrypted secrets
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, ... }:
    let
      system = "aarch64-linux";
      nixname = "vm-aarch64";
      pkgs = nixpkgs.legacyPackages.${system};
      nixos-rebuild-wrapper = name: action: pkgs.writeShellApplication {
        inherit name;
        text = ''
          echo "> Running nixos-rebuild ${action}..."
          NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild ${action} --sudo --flake ".#${nixname}"
          echo "> nixos-rebuild ${action} was successful ✅"
        '';
      };
    in
    {
      # Formatter configuration for `nix fmt`
      formatter.${system} = pkgs.nixfmt-rfc-style;

      devShells.${system}.default = pkgs.mkShellNoCC {
        name = "dotfiles";
        packages = [
          (nixos-rebuild-wrapper "switch" "switch")
          (nixos-rebuild-wrapper "try" "test")
        ];
      };

      nixosConfigurations.${nixname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit home-manager sops-nix; };
        modules = [
          ./machines/vm-aarch64.nix
        ];
      };
    };
}
