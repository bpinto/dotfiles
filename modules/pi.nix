# Pi coding agent for microVMs.
#
# Mounts the host's .pi/agent/ directory via virtiofs and points
# PI_CODING_AGENT_DIR at the mount.  Files on the host must be
# world-readable (644) since virtiofs maps the macOS uid to root
# inside the VM.
{ pkgs, ... }:

{
  # ── virtiofs share ──────────────────────────────────────────────────
  microvm.shares = [
    {
      proto = "virtiofs";
      tag = "pi-agent";
      source = "/Users/bpinto/src/dotfiles/users/shared/dotfiles/.pi/agent";
      mountPoint = "/mnt/pi-agent";
    }
  ];

  # ── Packages ────────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    fd
    nodejs
    ripgrep
  ];

  # ── Installation ────────────────────────────────────────────────────
  # Install pi globally via npm; persists on /var across reboots.
  systemd.services.pi-install = {
    description = "Install pi coding agent via npm";
    wantedBy = [ "multi-user.target" ];
    after = [
      "network-online.target"
      "home.mount"
    ];
    wants = [ "network-online.target" ];
    unitConfig.RequiresMountsFor = [ "/home" ];
    path = with pkgs; [
      bash
      coreutils
      nodejs
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "dev";
      Group = "users";
      Environment = "HOME=/home/dev";
    };
    script = ''
      export npm_config_prefix=/home/dev/.npm-global
      mkdir -p /home/dev/.npm-global

      # Skip if already installed
      if [ -x /home/dev/.npm-global/bin/pi ]; then
        echo "pi already installed, skipping"
        exit 0
      fi

      npm install -g @mariozechner/pi-coding-agent
    '';
  };

  # ── Environment ─────────────────────────────────────────────────────
  environment.variables.PI_CODING_AGENT_DIR = "/mnt/pi-agent";

  environment.shellInit = ''
    export PATH="/home/dev/.npm-global/bin:$PATH"
  '';
}
