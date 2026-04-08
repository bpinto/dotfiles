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
        | sort \
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
        | sort \
        | fzf --prompt="Select VM: " --height=~10 --layout=reverse) || exit 0
    fi
  '';

  # Resolve a VM name to its static IP address declared in the VM nix
  # file. Static IP must be set in machines/microvms/<vm>.nix as
  # `staticIpAddress = "192.168.64.X";`.
  resolveIP = ''
    VM_NIX="$HOME/src/dotfiles/machines/microvms/$VM.nix"
    VM_IP=$(sed -n 's/^[[:space:]]*staticIpAddress[[:space:]]*=[[:space:]]*"\(.*\)".*/\1/p' "$VM_NIX" | head -n1)
  '';

  # Common SSH options for connecting to microVMs.
  # accept-new: auto-accept the host key on first connect, reject if it
  # changes later (TOFU).
  sshOpts = "-A -o StrictHostKeyChecking=accept-new -o LogLevel=ERROR -i ~/.ssh/id_ed25519";

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
        VM_NAME="$VM-vm"
        PIDFILE="$VM_DIR/$VM_NAME.pid"

        mkdir -p "$VM_DIR"

        if [ -S "$VM_DIR/control.socket" ]; then
          echo "Error: $VM_NAME is already running"
          exit 1
        fi

        echo "> Starting $VM_NAME from $VM_DIR"
        cd "$VM_DIR"

        cleanup() {
          if [ "$DAEMON" != true ]; then
            rm -f "$VM_DIR/control.socket" "$PIDFILE"
          fi
        }
        trap cleanup EXIT

        if [ "$DAEMON" = true ]; then
          LOG="$VM_DIR/$VM_NAME.log"
          script -q "$LOG" nix run "path:$HOME/src/dotfiles#$VM_NAME" > /dev/null 2>&1 &
          echo "$!" > "$PIDFILE"
          echo "> $VM_NAME running in background (pid $(cat "$PIDFILE"), log: $LOG)"
        else
          nix run "path:$HOME/src/dotfiles#$VM_NAME"
        fi
      '';
    })

    (pkgs.writeShellApplication {
      name = "vm-stop";
      runtimeInputs = runtimeInputs ++ [
        pkgs.curl
        pkgs.procps
      ];
      text = ''
        FORCE=false
        while [[ "''${1:-}" == -* ]]; do
          case "$1" in
            --force) FORCE=true; shift ;;
            *) echo "Unknown option: $1"; exit 1 ;;
          esac
        done

        ${selectFromRunning}
        VM_DIR="$HOME/microvm/$VM"
        VM_NAME="$VM-vm"
        SOCKET="$VM_DIR/control.socket"
        PIDFILE="$VM_DIR/$VM_NAME.pid"

        if [ ! -S "$SOCKET" ]; then
          echo "Error: $VM_NAME is not running (no socket at $SOCKET)"
          exit 1
        fi

        echo "> Stopping $VM_NAME..."
        curl -s --unix-socket "$SOCKET" \
          -X POST \
          -H "Content-Type: application/json" \
          -d '{"state": "Stop"}' \
          http://localhost/vm/state || true

        # Wait for the VM process to fully exit before returning.
        echo "> Waiting for $VM_NAME to shut down..."
        STOPPED=false
        if [ -f "$PIDFILE" ]; then
          PID=$(cat "$PIDFILE")
          if [ -n "$PID" ]; then
            for _ in $(seq 1 10); do
              if ! kill -0 "$PID" > /dev/null 2>&1; then
                STOPPED=true
                break
              fi
              sleep 1
            done
          fi
        else
          for _ in $(seq 1 10); do
            if ! pgrep -f "$VM_NAME" > /dev/null 2>&1; then
              STOPPED=true
              break
            fi
            sleep 1
          done
        fi

        if [ "$STOPPED" = true ]; then
          rm -f "$SOCKET" "$PIDFILE"
          echo "> $VM_NAME stopped ✅"
          exit 0
        fi

        if [ "$FORCE" != true ]; then
          if [ -t 0 ]; then
            read -r -p "> $VM_NAME did not stop in time. Force kill it? [y/N] " REPLY
            case "$REPLY" in
              [yY]|[yY][eE][sS]) FORCE=true ;;
              *)
                echo "> Aborted. You can run: vm-stop --force $VM"
                exit 1
                ;;
            esac
          else
            echo "Error: $VM_NAME did not stop in time. Retry with --force"
            exit 1
          fi
        fi

        if [ -f "$PIDFILE" ]; then
          PID=$(cat "$PIDFILE")
          if [ -n "$PID" ] && kill -0 "$PID" > /dev/null 2>&1; then
            echo "> Force-stopping $VM_NAME (pid $PID)..."
            kill "$PID" > /dev/null 2>&1 || true

            for _ in $(seq 1 5); do
              if ! kill -0 "$PID" > /dev/null 2>&1; then
                break
              fi
              sleep 1
            done

            if kill -0 "$PID" > /dev/null 2>&1; then
              echo "> Process still alive, sending SIGKILL..."
              kill -9 "$PID" > /dev/null 2>&1 || true
            fi
          else
            echo "> PID from pidfile is not running (stale pid file), cleaning up..."
          fi
        else
          echo "Error: cannot force stop without pid file at $PIDFILE"
          exit 1
        fi

        rm -f "$PIDFILE" "$SOCKET"
        echo "> $VM_NAME force-stopped ✅"
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
