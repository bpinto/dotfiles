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
    ../../modules/git.nix
    ../../modules/neovim.nix
  ];

  # Start ssh-agent so git commit signing and SSH operations work.
  services.ssh-agent.enable = true;

  home.stateVersion = "25.11";

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
