{ pkgs, ... }:

{
  users.users.bpinto = {
    isNormalUser = true;
    home = "/home/bpinto";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.nushell;

    # Set a default password. Change it after first boot with `passwd`.
    # You can generate a hash with: mkpasswd -m sha-512
    hashedPassword = "$6$d4aHfz4/ww6Tcf7c$gZWWVQCsGS0iuVTOj2ThTEcQ/QoKJhxGFFoW3IbiHoPQBfE7vQ8dEmQ.qAmQPw3oyyh2rEHAp17GwP7e/oXVV/";

    openssh.authorizedKeys.keys = [
      # Add your SSH public key here, e.g.:
      # "ssh-ed25519 AAAA... bpinto"
    ];
  };
}
