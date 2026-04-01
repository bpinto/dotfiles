# Home-manager module for microVMs.
#
# Wires up home-manager with global packages, nixvim, sops-nix, and all
# the pi/agent extension inputs. Configures the `dev` user.
{
  dgalarza-claude-code-workflows,
  mitsuhiko-agent-stuff,
  nixvim,
  sops-nix,
  spnngl-pi-ext,
  unstablePkgs,
  vercel-labs-agent-skills,
  vmName,
  ...
}:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit
        dgalarza-claude-code-workflows
        mitsuhiko-agent-stuff
        sops-nix
        spnngl-pi-ext
        unstablePkgs
        vercel-labs-agent-skills
        ;
    };

    sharedModules = [
      ../shared-home-manager.nix
      nixvim.homeModules.nixvim
      sops-nix.homeManagerModules.sops
      { isMicrovm = true; }
    ];

    users.dev = {
      imports = [ ../../users/dev/home-manager.nix ];
      sops.defaultSopsFile = ../../secrets/${vmName}.yaml;
    };
  };
}
