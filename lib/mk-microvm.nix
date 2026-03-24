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
  nixpkgs,
  microvm,
  home-manager,
  nixpkgs-unstable,
}:

name:
nixpkgs.lib.nixosSystem {
  system = "aarch64-linux";
  specialArgs = {
    # The NixOS guest is aarch64-linux but the runner (vfkit) executes
    # on the macOS host, so it needs aarch64-darwin packages.
    hostPkgs = nixpkgs.legacyPackages.aarch64-darwin;
    vmName = name;

    # Provide a package set from nixpkgs-unstable to modules that need
    # individual unstable packages (e.g., pi-coding-agent).
    unstablePkgs = nixpkgs-unstable.legacyPackages.${"aarch64-linux"};
  };
  modules = [
    microvm.nixosModules.microvm
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        sharedModules = [
          ../modules/shared-home-manager.nix
          { isMicrovm = true; }
        ];
        users.dev = import ../users/dev/home-manager.nix;
      };
    }
    ../machines/microvms/${name}.nix
  ];
}
