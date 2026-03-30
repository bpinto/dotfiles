# Shared Pi agent configuration for home-manager.
#
# Adds pi-coding-agent and installs all shared Pi skills/extensions.
{ unstablePkgs, ... }:

{
  imports = [
    ./extensions/agent-stuff.nix
    ./extensions/nushell.nix
    ./skills/conventional-commits.nix
    ./skills/react.nix
  ];

  home.packages = [ unstablePkgs.pi-coding-agent ];
}
