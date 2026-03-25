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
  home.shell.enableNushellIntegration = true;

  programs.nushell = {
    enable = true;

    # Delta (git pager) needs COLORTERM to detect true-color support;
    # nushell doesn't inherit/set it automatically like fish/zsh.
    environmentVariables.COLORTERM = "truecolor";

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

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;

    # Custom theme using Tokyo Night Storm palette colors.
    settings =
      let
        dirBlue = "#61AFEF";
        branchGray = "#ABB2BF";
        dirtyAmber = "#FCBC47";
        stagedGreen = "#9ece6a";
        upstreamCyan = "#7dcfff";
        kubeYellow = "#E0AF68";
        promptMagenta = "#bb9af7";
        promptRed = "#f7768e";
        dimGray = "#a9b1d6";
      in
      {
        format = builtins.concatStringsSep "" [
          "$directory"
          "$git_branch"
          "$git_state"
          "$git_status"
          "$kubernetes"
          "$fill"
          "$hostname"
          "$line_break"
          "$character"
        ];

        directory = {
          style = config.directoryColor;
          truncation_length = 0;
          truncate_to_repo = false;
        };

        character = {
          success_symbol = "[❯](${promptMagenta})";
          error_symbol = "[❯](${promptRed})";
          vimcmd_symbol = "[❮](${stagedGreen})";
        };

        git_branch = {
          format = "[$branch]($style)";
          style = branchGray;
        };

        git_state = {
          format = " [$state( $progress_current/$progress_total)]($style)";
          style = dimGray;
        };

        git_status = {
          format = "([ *$modified$deleted](${dirtyAmber}))([ $staged](${stagedGreen}))([ $ahead_behind](${stagedGreen}))";
          modified = "​"; # zero-width space to trigger the group
          deleted = "​";
          staged = "⇢";
          ahead = "⇡";
          behind = "⇣";
          diverged = "⇡⇣";
        };

        fill.symbol = " ";

        hostname = {
          ssh_only = true; # only show when SSH'd into a microVM
          format = "[$hostname]($style)";
          style = dimGray;
        };

        kubernetes = {
          disabled = false;
          format = " [$context]($style)";
          style = kubeYellow;
          contexts = [
            {
              context_pattern = "orbstack";
              style = kubeYellow;
              context_alias = "";
            }
          ];
        };
      };
  };
}
