# Shared Git configuration for home-manager.
#
# Enables git with the shared .gitconfig (includes aliases, delta, signing, etc.)
# and symlinks supporting dotfiles (.git_template, .gitmessage)
# from the shared dotfiles mount (/mnt/dotfiles).
{
  config,
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

  # Whitelist/support symlinks for git supporting files
  home.file.".git_template".source = mkSymlink "${dotfiles}/.git_template";
  home.file.".gitmessage".source = mkSymlink "${dotfiles}/.gitmessage";
  home.file.".gitconfig".source = mkSymlink "${dotfiles}/.gitconfig";

}
