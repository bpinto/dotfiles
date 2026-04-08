# Home-manager configuration for the dev user in microVMs.
#
# Minimal setup: neovim and essential tools.
# No graphical environment.
{ config, ... }:
{
  imports = [
    ../../modules/bat.nix
    ../../modules/direnv.nix
    ../../modules/git.nix
    ../../modules/neovim
    ../../modules/nushell.nix
    ../../modules/ssh.nix
  ];

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    age.sshKeyPaths = [ ];
  };

  home.stateVersion = "25.11";

  xdg.enable = true;
}
