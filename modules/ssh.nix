{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "github.com" = {
        identityFile = "~/.ssh/github";
        addKeysToAgent = "no";
      };
    };
  };
}
