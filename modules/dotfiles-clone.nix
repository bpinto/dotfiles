{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Systemd service to clone the dotfiles repository once on bootstrap
  systemd.services.dotfiles-clone = {
    description = "Clone dotfiles repository from GitHub (one-time)";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    # Only run if the directory doesn't exist
    unitConfig = {
      ConditionPathExists = "!/home/bpinto/src/dotfiles";
    };

    serviceConfig = {
      Type = "oneshot";
      User = "bpinto";
      Group = "users";
      WorkingDirectory = "/home/bpinto";
    };

    script = ''
      REPO_URL="https://github.com/bpinto/dotfiles"
      REPO_PATH="/home/bpinto/src/dotfiles"

      echo "Creating src directory..."
      mkdir -p /home/bpinto/src

      echo "Cloning dotfiles repository..."
      ${pkgs.git}/bin/git clone "$REPO_URL" "$REPO_PATH"

      echo "Dotfiles repository cloned successfully at $(date)"
    '';
  };
}
