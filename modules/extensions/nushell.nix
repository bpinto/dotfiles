# Nushell extension for Pi agent (from spnngl/pi-ext).
#
# Installs the nushell extension into ~/.pi/agent/extensions/.
# The source is pinned to a specific commit in flake.nix. To upgrade,
# update the commit SHA there and run `nix flake lock`.
{ spnngl-pi-ext, ... }:

{
  home.file.".pi/agent/extensions/nushell" = {
    source = "${spnngl-pi-ext}/extensions/nushell";
    recursive = true;
  };
}
