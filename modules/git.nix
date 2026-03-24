# Shared Git configuration for home-manager.
#
# Enables git with the shared .gitconfig (includes aliases, delta, signing, etc.)
# and symlinks supporting dotfiles (.git_template, .gitmessage, allowed_signers)
# from the shared dotfiles mount (/mnt/dotfiles).
{
  config,
  lib,
  pkgs,
  ...
}:

let
  home = config.home.homeDirectory;
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  dotfiles = config.dotfilesPath;
in
{
  home.packages = with pkgs; [
    delta # Git pager with syntax highlighting
    fzf
  ];

  programs.git = {
    enable = true;
    includes = [
      { path = "${home}/.gitconfig"; }
    ];
  };

  # Start ssh-agent so git commit signing and SSH operations work.
  services.ssh-agent.enable = true;

  # Whitelist/support symlinks for git supporting files
  home.file.".git_template".source = mkSymlink "${dotfiles}/.git_template";
  home.file.".gitmessage".source = mkSymlink "${dotfiles}/.gitmessage";
  home.file.".gitconfig".source = mkSymlink "${dotfiles}/.gitconfig";
  home.file.".ssh/allowed_signers".source = mkSymlink "${dotfiles}/.ssh/allowed_signers";
}
