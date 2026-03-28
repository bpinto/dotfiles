# Home-manager configuration for the dev user in microVMs.
#
# Minimal setup: neovim and essential tools.
# No graphical environment.
{ unstablePkgs, ... }:
{
  imports = [
    ../../modules/bat.nix
    ../../modules/direnv.nix
    ../../modules/git.nix
    ../../modules/neovim
    ../../modules/nushell.nix
    ../../modules/ssh.nix
  ];

  home.packages = [ unstablePkgs.pi-coding-agent ];

  home.stateVersion = "25.11";

  xdg.enable = true;
}
