{
  config,
  lib,
  pkgs,
  ...
}:

let
  home = config.home.homeDirectory;
  dotfiles = "${home}/src/dotfiles";
  isLinux = pkgs.stdenv.isLinux;
in
{
  imports = [
    ../../modules/theme.nix
  ];

  home.stateVersion = "25.11";

  # SOPS
  sops = {
    age.keyFile = "${home}/.ssh/nixos_vm.age";
    age.sshKeyPaths = [ ];
    defaultSopsFile = ./../../secrets/nixos.yaml;
  };

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  home.packages = with pkgs; [
    delta
    fzf
    ghostty
    ripgrep
    tree
  ] ++ (lib.optionals isLinux [
    # i3-related tools
    rofi        # Application launcher
    i3lock      # Screen locker
    xss-lock    # Automatic screen locker on suspend
  ]);

  #---------------------------------------------------------------------
  # Environment
  #---------------------------------------------------------------------

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    PAGER = "less -FirSwX";
  };

  services.ssh-agent.enable = true;

  # XDG config files
  xdg.configFile = {
    # i3 window manager configuration (Linux only)
    "i3/config" = lib.mkIf isLinux { text = builtins.readFile ./i3; };
  };

  xdg.enable = true;


  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  #
  # Bash
  programs.bash = {
    enable = true;
  };

  #
  # Direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  #
  # Git
  home.file.".gitignore".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.gitignore";
  home.file.".gitmessage".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.gitmessage";
  home.file.".git_template".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.git_template";
  home.file.".ssh/allowed_signers".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.ssh/allowed_signers";

  programs.git = {
    enable = true;
    includes = [
      { path = "${dotfiles}/.gitconfig"; }
    ];
  };

  #
  # i3status
  programs.i3status = {
    enable = isLinux;

    general = {
      colors = true;
    };

    modules = {
      ipv6.enable = false;
      "battery all".enable = false;
      "wireless _first_".enable = false;
    };
  };

  #
  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  #
  # Nushell
  programs.nushell = {
    enable = true;
  };

  #
  # Starship
  programs.starship = {
    enable = true;
  };
}
