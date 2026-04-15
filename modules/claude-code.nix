# Shared Claude Code configuration for home-manager.
#
# Adds Claude Code CLI and manages ~/.claude/settings.json
# for all microVMs that import this module.
{ pkgs, ... }:

{
  home.packages = [ pkgs.claude-code ];

  home.file.".claude/settings.json".text = builtins.toJSON {
    autoUpdates = false;
    disableAllHooks = true;
    mcpServers = { };
    permissions = {
      deny = [
        "Read(**/*.cer)"
        "Read(**/*.crt)"
        "Read(**/*.der)"
        "Read(**/*.jks)"
        "Read(**/*.key)"
        "Read(**/*.p12)"
        "Read(**/*.p7b)"
        "Read(**/*.p7c)"
        "Read(**/*.pem)"
        "Read(**/*.pfx)"
        "Read(**/*.ppk)"
        "Read(**/credentials)"
        "Read(**/credentials/**)"
      ];
    };
    telemetry = false;
    theme = "dark";
  };
}
