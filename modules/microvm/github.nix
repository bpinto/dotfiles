# GitHub SSH settings for microVMs.
# Provides an IdentityFile for github.com and adds GitHub's host key
# to programs.ssh.knownHosts so non-interactive clones work.
{ pkgs, ... }:

{
  programs.ssh.extraConfig = ''
    Host github.com
      IdentityFile /home/dev/.ssh/github
      AddKeysToAgent yes
  '';

  programs.ssh.knownHosts.github = {
    hostNames = [ "github.com" ];
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
  };
}
