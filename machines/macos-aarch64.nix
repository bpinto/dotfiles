{
  home-manager,
  nixpkgs-unstable,
  nixvim,
  pkgs,
  sops-nix,
  ...
}:

let
  unstablePkgs = nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  # ── Imports ─────────────────────────────────────────────────────────

  imports = [
    home-manager.darwinModules.home-manager
    ../modules/macos.nix
    ../users/bpinto/darwin.nix
  ];

  # ── Configuration ───────────────────────────────────────────────────

  config = {
    fonts.packages = with pkgs; [
      nerd-fonts.victor-mono
      powerline-fonts
    ];

    home-manager = {
      extraSpecialArgs = { inherit unstablePkgs; };

      sharedModules = [
        nixvim.homeModules.nixvim
        sops-nix.homeManagerModules.sops
        ../modules/shared-home-manager.nix
      ];

      useGlobalPkgs = true;
      useUserPackages = true;

      # Configure users
      users.bpinto = {
        imports = [ ../users/bpinto/home-manager.nix ];

        # Starship directory color — blue
        directoryColor = "#61AFEF";
      };
    };

    nix = {
      # Enable flakes
      extraOptions = ''
        experimental-features = nix-command flakes
      '';

      # Linux builder VM for cross-compiling aarch64-linux (e.g., microVMs)
      linux-builder = {
        enable = true;
        config = {
          virtualisation = {
            cores = 4;
            darwin-builder.memorySize = 8 * 1024;
          };
        };
      };

      # Use latest nix version
      package = pkgs.nixVersions.latest;

      settings = {
        trusted-users = [ "bpinto" ];
      };
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Use Touch ID for sudo authentication
    security.pam.services.sudo_local.touchIdAuth = true;

    system = {
      # Used for backwards compatibility
      stateVersion = 6;

      # Required by nix-darwin for user-specific options.
      primaryUser = "bpinto";
    };

    time.timeZone = "Europe/Lisbon";
  };
}
