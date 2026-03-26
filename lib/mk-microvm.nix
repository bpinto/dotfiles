# Build a microVM NixOS configuration.
#
# Each name maps to:
#   module:  ./machines/microvms/<name>.nix
#   nixos:   nixosConfigurations.<name>-vm
#   package: packages.aarch64-darwin.<name>-vm  (nix run .#<name>-vm)
#
# Usage in flake.nix:
#   mkMicroVM = import ./lib/mk-microvm.nix { inherit nixpkgs microvm home-manager; };
#   nixosConfigurations.dotfiles-vm = mkMicroVM "dotfiles";
{
  dgalarza-claude-code-workflows,
  nixpkgs,
  microvm,
  home-manager,
  nixpkgs-unstable,
  nixvim,
  vercel-labs-agent-skills,
}:

name:
nixpkgs.lib.nixosSystem {
  system = "aarch64-linux";
  specialArgs = {
    inherit
      dgalarza-claude-code-workflows
      nixvim
      vercel-labs-agent-skills
      ;
    # The NixOS guest is aarch64-linux but the runner (vfkit) executes
    # on the macOS host, so it needs aarch64-darwin packages.
    hostPkgs = nixpkgs.legacyPackages.aarch64-darwin;
    unstablePkgs = nixpkgs-unstable.legacyPackages.aarch64-linux;
    vmName = name;
  };

  modules = [
    microvm.nixosModules.microvm
    home-manager.nixosModules.home-manager
    ../machines/microvms/${name}.nix
  ];
}
