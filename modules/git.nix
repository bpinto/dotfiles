# Shared Git configuration for home-manager.
#
# Enables git with the shared .gitconfig (includes aliases, delta, signing, etc.)
# and symlinks supporting dotfiles (.git_template, .gitmessage)
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
    delta
    fzf
    gnupg
    pinentry-curses # Terminal-based passphrase prompt for GPG
  ];

  programs.git = {
    enable = true;
    includes = [
      { path = "${home}/.gitconfig"; }
    ];
  };

  # Start ssh-agent so SSH operations work.
  services.ssh-agent = {
    enable = true;
    enableNushellIntegration = true;
  };

  # GPG agent for commit signing passphrase caching.
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
  };

  # Whitelist/support symlinks for git supporting files
  home.file.".git_template".source = mkSymlink "${dotfiles}/.git_template";
  home.file.".gitmessage".source = mkSymlink "${dotfiles}/.gitmessage";
  home.file.".gitconfig".source = mkSymlink "${dotfiles}/.gitconfig";
}
