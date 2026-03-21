{
  config,
  lib,
  pkgs,
  ...
}:

let
  home = config.home.homeDirectory;
  dotfiles = "${home}/src/dotfiles/users/bpinto/dotfiles";
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;

  # Colorized manpages using bat
  # https://github.com/sharkdp/bat/issues/1145
  manpager = pkgs.writeShellScriptBin "manpager" (
    if isLinux then
      ''
        cat "$1" | col -bx | bat --language man --style plain
      ''
    else
      ''
        sh -c 'col -bx | bat -l man -p'
      ''
  );
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

  home.packages =
    with pkgs;
    [
      age
      awscli2
      ctags-lsp
      delta
      fish
      gh
      helmfile
      k9s
      kubectx
      nodejs
      prettierd
      ripgrep
      sops
      stylua
      ticker
      tree
      universal-ctags
      yt-dlp
    ]
    ++ (lib.optionals isDarwin [
      aws-vault
      discord
      ghostty-bin
      google-chrome
      orbstack
      pinentry_mac
      shiori
      slack
      ssm-session-manager-plugin
      tailscale
    ])
    ++ (lib.optionals isLinux [
      esphome
      ghostty
      xclip
    ])
    ++ (lib.optionals isLinux [
      # i3-related tools
      i3lock # Screen locker
      rofi # Application launcher
      xss-lock # Automatic screen locker on suspend
    ]);

  #---------------------------------------------------------------------
  # Environment
  #---------------------------------------------------------------------

  # HiDPI cursor — without this the cursor is tiny at high resolutions
  home.pointerCursor = lib.mkIf isLinux {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
  };

  # Clipboard aliases so macOS muscle memory works on Linux
  home.shellAliases = lib.mkIf isLinux {
    pbcopy = "xclip";
    pbpaste = "xclip -o";
  };

  home.sessionPath = [ "$HOME/.npm-global/bin" ];

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    MANPAGER = "${manpager}/bin/manpager";
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    PAGER = "less -FirSwX";
  };

  services.ssh-agent.enable = isLinux;

  # XDG config files
  xdg.configFile = {
    # Fish shell configuration
    "fish" = {
      source = mkSymlink "${dotfiles}/.config/fish";
    };

    # Ghostty terminal configuration (Linux uses a separate config file)
    "ghostty/config" =
      if isLinux then
        { text = builtins.readFile ./ghostty.linux; }
      else
        { source = mkSymlink "${dotfiles}/.config/ghostty/config"; };

    # i3 window manager configuration (Linux only)
    "i3/config" = lib.mkIf isLinux { text = builtins.readFile ./i3; };

    # k9s configuration
    "k9s" = {
      source = mkSymlink "${dotfiles}/.config/k9s";
    };

    # Neovim configuration
    "nvim" = {
      source = mkSymlink "${dotfiles}/.config/nvim";
    };

    # Projectionist configuration
    "projections.json" = {
      source = mkSymlink "${dotfiles}/.config/projections.json";
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

  # Bat
  home.activation.batCacheBuild = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.bat}/bin/bat cache --build 2>/dev/null || true
  '';
  programs.bat = {
    enable = true;
    config.theme = "tokyonight_storm";
    themes = {
      tokyonight_storm = {
        src = ./dotfiles/.config/bat/themes/tokyonight_storm.tmTheme;
      };
    };
  };

  # Ctags
  home.file.".ctags".source = mkSymlink "${dotfiles}/.ctags";

  # Direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Git
  home.file.".git_template".source = mkSymlink "${dotfiles}/.git_template";
  home.file.".gitignore".source = mkSymlink "${dotfiles}/.gitignore";
  home.file.".gitmessage".source = mkSymlink "${dotfiles}/.gitmessage";
  home.file.".ssh/allowed_signers".source = mkSymlink "${dotfiles}/.ssh/allowed_signers";
  programs.git = {
    enable = true;
    includes = [
      { path = "${dotfiles}/.gitconfig"; }
    ];
  };

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

  # Neovim
  home.activation.neovimSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${home}/.local/share/nvim/backup"
    if [ ! -e "${home}/.local/share/nvim/lazy/lazy.nvim" ]; then
      mkdir -p "${home}/.local/share/nvim/lazy"
      ${pkgs.git}/bin/git clone --filter=blob:none \
        https://github.com/folke/lazy.nvim.git \
        --branch=stable \
        "${home}/.local/share/nvim/lazy/lazy.nvim"
    fi
  '';
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

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
