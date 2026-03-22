# Shared Neovim configuration for home-manager.
#
# Enables neovim and bootstraps the lazy.nvim plugin manager.
# Config files (nvim/, projections.json) must be placed at the
# XDG config path by the caller (symlinks, mounts, etc.).
{
  config,
  lib,
  pkgs,
  ...
}:

let
  home = config.home.homeDirectory;
in
{
  config = {
    home.activation.neovimSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${home}/.local/share/nvim/backup"
      if [ ! -d "${home}/.local/share/nvim/lazy/lazy.nvim" ]; then
        mkdir -p "${home}/.local/share/nvim/lazy"
        cp -r "${pkgs.vimPlugins.lazy-nvim}" "${home}/.local/share/nvim/lazy/lazy.nvim"
      fi
    '';

    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
}
