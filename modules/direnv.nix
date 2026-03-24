{ config, lib, ... }:

let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  dotfiles = config.dotfilesPath;
in
{
  # Enable direnv for users that import this module.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Place only the direnv.toml file via XDG configFile so ~/.config/direnv
  # remains a normal directory and nix-direnv can write its lib files.
  xdg.configFile = {
    "direnv/direnv.toml" = {
      source = mkSymlink "${dotfiles}/.config/direnv/direnv.toml";
    };
  };
}
