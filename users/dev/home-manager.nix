# Home-manager configuration for the dev user in microVMs.
#
# Minimal setup: neovim and essential tools.
# No graphical environment (no X11/i3/ghostty).
#
# Dotfiles are mounted at /mnt/dotfiles and selectively symlinked
# into ~/.config via xdg.configFile, following the same pattern as
# users/bpinto/home-manager.nix.
{
  config,
  ...
}:

let
  dotfiles = "/mnt/dotfiles";
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  imports = [
    ../../modules/bat.nix
    ../../modules/git.nix
    ../../modules/neovim.nix
  ];

  home.stateVersion = "25.11";

  programs = {
    # Bash must be managed by home-manager so session variables
    # (including SSH_AUTH_SOCK) are sourced on login.
    bash = {
      enable = true;
      initExtra = ''
        # Auto-add SSH key to agent when not already loaded.
        if ! ssh-add -l &>/dev/null; then
          ssh-add ~/.ssh/github &>/dev/null
        fi
      '';
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };

  # Start ssh-agent so git commit signing and SSH operations work.
  services.ssh-agent.enable = true;

  xdg.enable = true;

  # XDG config files
  xdg.configFile = {
    # Fish shell configuration
    "fish" = {
      source = mkSymlink "${dotfiles}/.config/fish";
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

  # Git supporting files
  home.file.".git_template".source = mkSymlink "${dotfiles}/.git_template";
  home.file.".gitconfig".source = mkSymlink "${dotfiles}/.gitconfig";
  home.file.".gitmessage".source = mkSymlink "${dotfiles}/.gitmessage";
  home.file.".ssh/allowed_signers".source = mkSymlink "${dotfiles}/.ssh/allowed_signers";
}
