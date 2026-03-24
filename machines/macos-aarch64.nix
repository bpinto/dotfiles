{
  home-manager,
  pkgs,
  sops-nix,
  ...
}:

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
      sharedModules = [
        sops-nix.homeManagerModules.sops
        ../modules/shared-home-manager.nix
      ];

      useGlobalPkgs = true;
      useUserPackages = true;

      # Configure users
      users.bpinto = import ../users/bpinto/home-manager.nix;
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

    # Configures system-level fish integration (/etc/fish/) so fish can find
    # Nix-installed programs. Fish is launched by the terminal emulator, not
    # set as the macOS login shell.
    programs.fish.enable = true;

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
