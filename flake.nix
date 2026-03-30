{
  description = "NixOS and macOS system configuration";

  inputs = {
    # home-manager module for user environment management
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # microvm.nix for lightweight NixOS VMs on macOS
    microvm.url = "github:astro/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";

    # nix-darwin module for macOS system configuration
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # An unstable nixpkgs input for a few bleeding-edge packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # NixVim — configure Neovim entirely in Nix
    nixvim.url = "github:nix-community/nixvim/nixos-25.11";

    # sops-nix module to handle encrypted secrets
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Conventional commits skill for Pi (dgalarza/claude-code-workflows)
    dgalarza-claude-code-workflows = {
      url = "github:dgalarza/claude-code-workflows/0bc28b28f949dc448753913e6f69479444f2241f";
      flake = false;
    };

    # Nushell extension for Pi (spnngl/pi-ext)
    spnngl-pi-ext = {
      url = "github:spnngl/pi-ext/505c0f9a9c0ebc528d11466a7f779c2b99f02de7";
      flake = false;
    };

    # React/Next.js agent skills for Pi (vercel-labs/agent-skills)
    vercel-labs-agent-skills = {
      url = "github:vercel-labs/agent-skills/64484e9a6022c81e3af59f5dcee6fb6d631bf53e";
      flake = false;
    };
  };

  outputs =
    {
      self,
      dgalarza-claude-code-workflows,
      home-manager,
      microvm,
      nix-darwin,
      nixpkgs,
      nixpkgs-unstable,
      nixvim,
      sops-nix,
      spnngl-pi-ext,
      vercel-labs-agent-skills,
      ...
    }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};

      mkMicroVM = import ./lib/mk-microvm.nix {
        inherit
          dgalarza-claude-code-workflows
          home-manager
          microvm
          nixpkgs
          nixpkgs-unstable
          nixvim
          spnngl-pi-ext
          vercel-labs-agent-skills
          ;
      };
    in
    {
      devShells.${system}.default = pkgs.mkShellNoCC {
        name = "dotfiles";
        packages = [
          nix-darwin.packages.${system}.darwin-rebuild
          (pkgs.writeShellApplication {
            name = "switch";
            text = "sudo darwin-rebuild switch --flake '.#macos-aarch64'";
          })
        ];
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
      formatter.aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.nixfmt-tree;

      #--------------------------------------------------------------------
      # System configurations (macOS)
      #--------------------------------------------------------------------

      darwinConfigurations.macos-aarch64 = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit home-manager nixvim sops-nix; };
        modules = [
          ./machines/macos-aarch64.nix
        ];
      };

      #--------------------------------------------------------------------
      # MicroVMs (aarch64-linux guests, launched via vfkit)
      #--------------------------------------------------------------------

      nixosConfigurations.cliniko-vm = mkMicroVM "cliniko";
      nixosConfigurations.dotfiles-vm = mkMicroVM "dotfiles";
      nixosConfigurations.homelab-vm = mkMicroVM "homelab";
      nixosConfigurations.predbat-vm = mkMicroVM "predbat";

      packages.aarch64-darwin.cliniko-vm =
        self.nixosConfigurations.cliniko-vm.config.microvm.declaredRunner;
      packages.aarch64-darwin.dotfiles-vm =
        self.nixosConfigurations.dotfiles-vm.config.microvm.declaredRunner;
      packages.aarch64-darwin.homelab-vm =
        self.nixosConfigurations.homelab-vm.config.microvm.declaredRunner;
      packages.aarch64-darwin.predbat-vm =
        self.nixosConfigurations.predbat-vm.config.microvm.declaredRunner;
    };
}
