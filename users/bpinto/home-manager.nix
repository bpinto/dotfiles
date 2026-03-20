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

  # Colorized manpages using bat
  # https://github.com/sharkdp/bat/issues/1145
  manpager = pkgs.writeShellScriptBin "manpager" (if isLinux then ''
    cat "$1" | col -bx | bat --language man --style plain
  '' else ''
    sh -c 'col -bx | bat -l man -p'
  '');
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
    ghostty
    ripgrep
    tree
    xclip
  ] ++ (lib.optionals isLinux [
    # i3-related tools
    rofi        # Application launcher
    i3lock      # Screen locker
    xss-lock    # Automatic screen locker on suspend
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

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    MANPAGER = "${manpager}/bin/manpager";
    PAGER = "less -FirSwX";
  };

  services.ssh-agent.enable = true;

  # XDG config files
  xdg.configFile = {
    # Ghostty terminal configuration (Linux only)
    "ghostty/config" = lib.mkIf isLinux { text = builtins.readFile ./ghostty.linux; };

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
  # Bat
  programs.bat = {
    enable = true;
    config.theme = "tokyonight_storm";
    themes = {
      tokyonight_storm = { src = ../../.config/bat/themes/tokyonight_storm.tmTheme; };
    };
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
