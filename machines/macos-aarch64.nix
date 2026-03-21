{
  config,
  home-manager,
  lib,
  pkgs,
  sops-nix,
  ...
}:

{
  imports = [
    home-manager.darwinModules.home-manager
    ../modules/macos.nix
    ../users/bpinto/darwin.nix
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.victor-mono
    powerline-fonts
  ];

  home-manager = {
    sharedModules = [
      sops-nix.homeManagerModules.sops
    ];

    useGlobalPkgs = true;
    useUserPackages = true;

    # Configure users
    users.bpinto = import ../users/bpinto/home-manager.nix;
  };

  # Configures system-level fish integration (/etc/fish/) so fish can find
  # Nix-installed programs. Fish is launched by the terminal emulator, not
  # set as the macOS login shell.
  programs.fish.enable = true;

  # Required by nix-darwin for user-specific options.
  system.primaryUser = "bpinto";

  nix = {
    # Enable flakes
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

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
  };

  time.timeZone = "Europe/Lisbon";
}
