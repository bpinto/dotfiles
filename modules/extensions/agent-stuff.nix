# Selected Pi extensions from mitsuhiko/agent-stuff.
#
# Installs answer, review, and notify into ~/.pi/agent/extensions/.
# The source is pinned to a specific commit in flake.nix. To upgrade,
# update the commit SHA there and run `nix flake lock`.
{ mitsuhiko-agent-stuff, ... }:

let
  enabledExtensions = [
    "answer"
    "notify"
    "review"
  ];

  mkExtensionEntry = extension: {
    name = ".pi/agent/extensions/${extension}.ts";
    value = {
      source = "${mitsuhiko-agent-stuff}/pi-extensions/${extension}.ts";
    };
  };
in
{
  home.file = builtins.listToAttrs (map mkExtensionEntry enabledExtensions);
}
