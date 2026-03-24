{
  config,
  lib,
  pkgs,
  ...
}:

let
  home = config.home.homeDirectory;
  dotfiles = "${home}/src/dotfiles/users/shared/dotfiles";
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;

  # Colorized manpages using bat
  # https://github.com/sharkdp/bat/issues/1145
  manpager = pkgs.writeShellScriptBin "manpager" (''
    sh -c 'col -bx | bat -l man -p'
  '');
in
{
  imports = [
    ../../lib/vm-scripts.nix
    ../../modules/bat.nix
    ../../modules/direnv.nix
    ../../modules/git.nix
    ../../modules/neovim.nix
    ../../modules/ssh.nix
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
    age
    awscli2
    aws-vault
    ctags-lsp
    discord
    fish
    gh
    ghostty-bin
    google-chrome
    helmfile
    k9s
    kubectx
    nodejs
    orbstack
    pinentry_mac
    prettierd
    ripgrep
    shiori
    slack
    sops
    ssm-session-manager-plugin
    stylua
    tailscale
    ticker
    tree
    universal-ctags
    yt-dlp
  ];

  #---------------------------------------------------------------------
  # Environment
  #---------------------------------------------------------------------

  home.sessionPath = [ "$HOME/.npm-global/bin" ];

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    MANPAGER = "${manpager}/bin/manpager";
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    PAGER = "less -FirSwX";
  };

  # XDG config files
  xdg.configFile = {
    # Fish shell configuration
    "fish" = {
      source = mkSymlink "${dotfiles}/.config/fish";
    };

    # Ghostty terminal configuration
    "ghostty/config" = {
      source = mkSymlink "${dotfiles}/.config/ghostty/config";
    };

    # k9s configuration
    "k9s" = {
      source = mkSymlink "${dotfiles}/.config/k9s";
    };
  };

  xdg.enable = true;

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  # Bash
  programs.bash = {
    enable = true;
  };

  # Ctags
  home.file.".ctags".source = mkSymlink "${dotfiles}/.ctags";

  # Nushell
  programs.nushell = {
    enable = true;
  };

  # Starship
  programs.starship = {
    enable = true;
  };

  # Ticker
  home.file.".ticker.yaml".source = mkSymlink "${home}/Documents/.ticker.yaml";
}
