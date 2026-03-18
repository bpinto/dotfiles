{ config, lib, pkgs, ... }:

{
  home.stateVersion = "25.11";

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  home.packages = with pkgs; [
    ripgrep
    starship
    tree
  ];

  #---------------------------------------------------------------------
  # Environment
  #---------------------------------------------------------------------

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    PAGER = "less -FirSwX";
  };

  # XDG environment variables
  xdg.enable = true;

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  programs.bash = {
    enable = true;
  };

  programs.neovim = {
    enable = true;

    defaultEditor = true;
  };

  programs.nushell = {
    enable = true;
  };

  programs.starship = {
    enable = true;
  };

  programs.direnv = {
    enable = true;

    nix-direnv.enable = true;
  };
}
