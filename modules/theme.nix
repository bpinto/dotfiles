# TokyoNight Storm theme
#
# Centralises color definitions so that all programs (i3, i3status,
# xresources, etc.) share a single palette.

{ lib, pkgs, ... }:

let
  isLinux = pkgs.stdenv.isLinux;

  colors = {
    background = "#24283b";
    foreground = "#c0caf5";
    color0     = "#1d202f";
    color1     = "#f7768e";
    color2     = "#9ece6a";
    color3     = "#e0af68";
    color4     = "#7aa2f7";
    color5     = "#bb9af7";
    color6     = "#7dcfff";
    color7     = "#a9b1d6";
    color8     = "#414868";
    color9     = "#f7768e";
    color10    = "#9ece6a";
    color11    = "#e0af68";
    color12    = "#7aa2f7";
    color13    = "#bb9af7";
    color14    = "#7dcfff";
    color15    = "#c0caf5";
  };
in
{
  # X resources — loads the palette into X so i3's set_from_resource
  # directives (and any other X application) pick up the colors.
  xresources.properties = lib.mkIf isLinux {
    "*.background" = colors.background;
    "*.foreground" = colors.foreground;
    "*.color0"  = colors.color0;
    "*.color1"  = colors.color1;
    "*.color2"  = colors.color2;
    "*.color3"  = colors.color3;
    "*.color4"  = colors.color4;
    "*.color5"  = colors.color5;
    "*.color6"  = colors.color6;
    "*.color7"  = colors.color7;
    "*.color8"  = colors.color8;
    "*.color9"  = colors.color9;
    "*.color10" = colors.color10;
    "*.color11" = colors.color11;
    "*.color12" = colors.color12;
    "*.color13" = colors.color13;
    "*.color14" = colors.color14;
    "*.color15" = colors.color15;
  };

  # i3status bar colors
  programs.i3status.general = lib.mkIf isLinux {
    color_good     = colors.color2;   # green
    color_bad      = colors.color1;   # red
    color_degraded = colors.color3;   # yellow
  };
}
