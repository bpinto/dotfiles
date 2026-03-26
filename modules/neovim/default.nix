# Shared Neovim configuration for home-manager using NixVim.
#
# All plugins, LSP servers, formatters, and treesitter grammars are
# managed declaratively through Nix
{
  config,
  lib,
  pkgs,
  ...
}:

let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  dotfiles = config.dotfilesPath;
in
{
  config = {
    # Projectionist configuration
    xdg.configFile."projections.json" = {
      source = mkSymlink "${dotfiles}/.config/projections.json";
    };

    home.activation.neovimSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${config.home.homeDirectory}/.local/share/nvim/backup"
    '';

    programs.nixvim = {
      enable = true;
      defaultEditor = true;

      nixpkgs.config.allowUnfree = true;

      # Enable lazy loading
      plugins.lz-n.enable = true;

      # Imported modules are scoped within the `programs.nixvim` submodule
      imports = [
        ./autocmds.nix
        ./keymaps.nix
        ./options.nix
        ./plugins/ai.nix
        ./plugins/completion.nix
        ./plugins/editor.nix
        ./plugins/formatting.nix
        ./plugins/git.nix
        ./plugins/lsp.nix
        ./plugins/search.nix
        ./plugins/snacks.nix
        ./plugins/treesitter.nix
        ./plugins/ui.nix
      ];
    };
  };
}
