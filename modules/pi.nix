# Pi agent home-manager module.
#
# Whitelists config files from the host mount (/mnt/pi-agent) into
# ~/.pi/agent/ while keeping sessions/ and bin/ local to each VM.
{ config, ... }:

let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  piAgent = "/mnt/pi-agent";
in
{
  home.file.".pi/agent/auth.json".source = mkSymlink "${piAgent}/auth.json";
  home.file.".pi/agent/settings.json".source = mkSymlink "${piAgent}/settings.json";
}
