# Shared Git configuration for home-manager.
#
# Enables git with the shared .gitconfig (includes aliases, delta, signing, etc.)
# and expects supporting dotfiles (.git_template, .gitmessage, allowed_signers)
# to be placed at the home directory by the caller (symlinks, mounts, etc.).
{
  config,
  ...
}:

let
  home = config.home.homeDirectory;
in
{
  programs.git = {
    enable = true;
    includes = [
      { path = "${home}/.gitconfig"; }
    ];
  };
}
