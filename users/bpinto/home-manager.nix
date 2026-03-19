{ config, lib, pkgs, ... }:

let
  home = config.home.homeDirectory;
  dotfiles = "${home}/src/dotfiles";
in
{
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
    ripgrep
    tree
  ];

  #---------------------------------------------------------------------
  # Environment
  #---------------------------------------------------------------------

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    PAGER = "less -FirSwX";
  };

  services.ssh-agent.enable = true;

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
  home.file.".ssh/allowed_signers".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.ssh/allowed_signers";

  programs.git = {
    enable = true;
    includes = [
      { path = "${dotfiles}/.gitconfig"; }
    ];
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

  # Starship
  programs.starship = {
    enable = true;
  };
}
