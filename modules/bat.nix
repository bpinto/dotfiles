# Shared bat configuration for home-manager.
#
# Installs bat with the tokyonight_storm theme and builds the theme cache.
# This is also required by delta (git pager) which uses bat's theme engine.
{
  lib,
  pkgs,
  ...
}:

{
  home.activation.batCacheBuild = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.bat}/bin/bat cache --build 2>/dev/null || true
  '';

  programs.bat = {
    enable = true;
    config.theme = "tokyonight_storm";
    themes = {
      tokyonight_storm = {
        src = ../users/shared/dotfiles/.config/bat/themes/tokyonight_storm.tmTheme;
      };
    };
  };
}
