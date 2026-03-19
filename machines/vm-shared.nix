{ config, pkgs, lib, home-manager, sops-nix, ... }:

{
  imports = [
    home-manager.nixosModules.home-manager
    sops-nix.nixosModules.sops

    # Import OS configurations
    ../users/bpinto/nixos.nix

    # Import services
    ../services/dotfiles-clone.nix
  ];

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Systemd-boot configuration for UEFI systems
  boot.loader = {
    efi.canTouchEfiVariables = true;

    systemd-boot = {
      enable = true;

      # VMware, Parallels both only support this being 0 otherwise you see
      # "error switching console mode" on boot.
      consoleMode = "0";

      # Limit to last 2 boot entries
      configurationLimit = 2;
    };
  };

  # System packages
  environment.systemPackages = with pkgs; [
    bash
    nixfmt

    # VMware clipboard support
    gtkmm3
  ];

  # Fonts
  fonts = {
    fontDir.enable = true;

    packages = with pkgs; [
      nerd-fonts.victor-mono
    ];
  };

  # Home Manager configuration
  home-manager = {
    # NixOS system-wide home-manager configuration
    sharedModules = [
      sops-nix.homeManagerModules.sops
    ];

    useGlobalPkgs = true;
    useUserPackages = true;

    # Configure users
    users.bpinto = import ../users/bpinto/home-manager.nix;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    # Hostname
    hostName = "nixos-dev";

    # Disable DHCP for all interfaces (systemd-networkd will handle it)
    useDHCP = false;
  };

  nix = {
    # Enable flakes
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # Use latest nix version
    package = pkgs.nixVersions.latest;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;

  # No desktop environment, just i3 window manager
  services.displayManager.defaultSession = "none+i3";

  # i3 window manager
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    dpi = 220;

    desktopManager = {
      xterm.enable = false;
      wallpaper.mode = "fill";
    };

    displayManager = {
      lightdm.enable = true;

      # AARCH64: For now, on Apple Silicon, we must manually set the
      # display resolution. This is a known issue with VMware Fusion.
      sessionCommands = ''
        ${pkgs.xorg.xset}/bin/xset r rate 200 40
      '';
    };

    windowManager = {
      i3.enable = true;
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;
  services.openssh.settings.PermitRootLogin = "no";

  # Enable systemd-resolved for DNS resolution
  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
  };

  # SOPS configuration
  sops = {
    age.keyFile = "/etc/ssh/nixos_vm.age";
    age.sshKeyPaths = [ ];
    defaultSopsFile = ./../secrets/nixos.yaml;
  };

  system.stateVersion = "25.11";

  # Timezone
  time.timeZone = "Europe/Lisbon";

  # Reset users and groups configuration on system activation
  users.mutableUsers = false;
}
