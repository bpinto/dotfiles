# Helper scripts for managing microVMs.
#
# Adds vm-start, vm-stop, vm-restart, and vm-ssh to home.packages.
{ pkgs, ... }:

let
  # Select a VM by argument or fzf picker from available VM definitions.
  selectFromDefinitions = ''
    if [ -n "''${1:-}" ]; then
      VM="$1"
      shift
    else
      VM=$(find "$HOME/src/dotfiles/machines/microvms" -name '*.nix' -exec basename {} .nix \; \
        | fzf --prompt="Select VM: " --height=~10 --layout=reverse) || exit 0
    fi
  '';

  # Select a VM by argument or fzf picker from running VMs only.
  selectFromRunning = ''
    if [ -n "''${1:-}" ]; then
      VM="$1"
      shift
    else
      VM=$(find "$HOME/microvm" -name 'control.socket' -type s -exec dirname {} \; \
        | while read -r d; do basename "$d"; done \
        | fzf --prompt="Select VM: " --height=~10 --layout=reverse) || exit 0
    fi
  '';

  # Resolve a VM name to its IP address from the macOS DHCP leases file.
  resolveIP = ''
    VM_IP=$(awk -v name="$VM-vm" '
      /^{/     { rec=""; n="" }
      /name=/  { n=$0; sub(/.*name=/, "", n) }
      /ip_address=/ { ip=$0; sub(/.*ip_address=/, "", ip) }
      /^}/     { if (n == name) print ip }
    ' /var/db/dhcpd_leases | tail -1)

    if [ -z "$VM_IP" ]; then
      echo "Error: could not find IP for $VM-vm in DHCP leases"
      exit 1
    fi
  '';

  # Common SSH options for connecting to microVMs.
  sshOpts = "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -i ~/.ssh/nixos_vm";

  runtimeInputs = with pkgs; [
    findutils
    fzf
  ];
in
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "vm-start";
      runtimeInputs = runtimeInputs ++ [ pkgs.coreutils ];
      text = ''
        DAEMON=false
        while [[ "''${1:-}" == -* ]]; do
          case "$1" in
            --daemon) DAEMON=true; shift ;;
            *) echo "Unknown option: $1"; exit 1 ;;
          esac
        done

        ${selectFromDefinitions}
        VM_DIR="$HOME/microvm/$VM"

        mkdir -p "$VM_DIR"

        if [ -S "$VM_DIR/control.socket" ]; then
          echo "Error: $VM-vm is already running"
          exit 1
        fi

        echo "> Starting $VM-vm from $VM_DIR"
        cd "$VM_DIR"

        cleanup() { rm -f "$VM_DIR/control.socket"; }
        trap cleanup EXIT

        if [ "$DAEMON" = true ]; then
          LOG="$VM_DIR/$VM-vm.log"
          script -q "$LOG" nix run "path:$HOME/src/dotfiles#$VM-vm" > /dev/null 2>&1 &
          echo "> $VM-vm running in background (pid $!, log: $LOG)"
        else
          nix run "path:$HOME/src/dotfiles#$VM-vm"
        fi
      '';
    })

    (pkgs.writeShellApplication {
      name = "vm-stop";
      runtimeInputs = runtimeInputs ++ [ pkgs.curl ];
      text = ''
        ${selectFromRunning}
        VM_DIR="$HOME/microvm/$VM"
        SOCKET="$VM_DIR/control.socket"

        if [ ! -S "$SOCKET" ]; then
          echo "Error: $VM-vm is not running (no socket at $SOCKET)"
          exit 1
        fi

        echo "> Stopping $VM-vm..."
        curl -s --unix-socket "$SOCKET" \
          -X POST \
          -H "Content-Type: application/json" \
          -d '{"state": "Stop"}' \
          http://localhost/vm/state
        rm -f "$SOCKET"
        echo "> $VM-vm stopped ✅"
      '';
    })

    (pkgs.writeShellApplication {
      name = "vm-restart";
      runtimeInputs = runtimeInputs;
      text = ''
        ${selectFromRunning}

        vm-stop "$VM"
        vm-start --daemon "$VM"
      '';
    })

    (pkgs.writeShellApplication {
      name = "vm-ssh";
      runtimeInputs = runtimeInputs ++ [ pkgs.gawk ];
      text = ''
        ${selectFromRunning}
        ${resolveIP}
        exec ssh ${sshOpts} "dev@$VM_IP" "$@"
      '';
    })
  ];
}
