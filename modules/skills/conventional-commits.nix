# Conventional commits skill for Pi agent (from dgalarza/claude-code-workflows).
#
# Installs the conventional-commits skill into ~/.pi/agent/skills/.
# The source is pinned to a specific commit in flake.nix. To upgrade,
# update the commit SHA there and run `nix flake lock`.
{ dgalarza-claude-code-workflows, ... }:

{
  home.file.".pi/agent/skills/conventional-commits" = {
    source = "${dgalarza-claude-code-workflows}/plugins/conventional-commits/skills/conventional-commits";
    recursive = true;
  };
}
