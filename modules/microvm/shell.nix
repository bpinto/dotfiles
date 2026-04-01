# Shell module for microVMs.
{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.defaultSshDirectory = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "Default directory to cd into on login.";
  };

  config = {
    environment.enableAllTerminfo = true;

    environment.interactiveShellInit = ''
      # Launch nushell for interactive sessions.
      # Bash remains the login shell for POSIX compatibility.
      if [[ $- == *i* && -z "$IN_NUSHELL" && "$(id -u)" -ne 0 ]]; then
        exec env IN_NUSHELL=1 nu --login
      fi
    '';

    environment.loginShellInit = lib.optionalString (config.defaultSshDirectory != null) ''
      if [ -d ${config.defaultSshDirectory} ]; then cd ${config.defaultSshDirectory}; fi
    '';

    environment.systemPackages = with pkgs; [
      ghostty.terminfo
    ];
  };
}
