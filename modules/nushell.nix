# Shared Nushell configuration for home-manager.
#
# We let programs.nushell own config.nu so that home-manager integrations
# (e.g. ssh-agent) can inject snippets into it. Our hand-written config is
# sourced from the shared dotfiles directory.
{
  config,
  lib,
  ...
}:

let
  dotfiles = config.dotfilesPath;
in
{
  programs.nushell = {
    enable = true;

    # Source our hand-written config from the shared dotfiles mount.
    extraConfig = ''
      source ${dotfiles}/.config/nushell/config.nu
    ''
    + lib.optionalString config.isMicrovm ''

      # Auto-add SSH key to agent on first interactive shell.
      if (ssh-add -l | complete).exit_code != 0 {
        ssh-add ~/.ssh/github
      }
    '';
  };

  home.shell.enableNushellIntegration = false;
}
