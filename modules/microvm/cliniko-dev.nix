# Cliniko dev module for microVMs.
#
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ awscli2 kubectl k9s nodejs_24 ];
}
