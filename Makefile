# Connectivity info for Linux VM
NIXADDR ?= unset
NIXPORT ?= 22
NIXUSER ?= bpinto

# Get the path to this Makefile and directory
MAKEFILE_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

# The name of the nixosConfiguration in the flake
NIXNAME ?= vm-aarch64

# SSH options that are used. These aren't meant to be overridden but are
# reused a lot so we just store them up here.
SSH_OPTIONS=-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no

# Primary disk device. VMware Fusion on Apple Silicon typically uses NVMe,
# while older versions or Intel VMs may use SATA.
# Override with: make vm/bootstrap0 NIXDISK=/dev/sda
NIXDISK ?= /dev/nvme0n1

switch:
	sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --flake ".#${NIXNAME}"

test:
	sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild test --flake ".#$(NIXNAME)"

# bootstrap a brand new VM. The VM should have NixOS ISO on the CD drive.
# Set the password of the root user to "root" before running this.
#
# This will partition the disk, format it, and install a minimal NixOS
# that we can then use to apply our full configuration.
#
# Supports both NVMe (/dev/nvme0n1) and SATA (/dev/sda) disk devices.
vm/bootstrap0:
	ssh $(SSH_OPTIONS) -p$(NIXPORT) root@$(NIXADDR) " \
		set -e; \
		DISK=$(NIXDISK); \
		case \$$DISK in \
			*nvme*) SEP=p;; \
			*) SEP=;; \
		esac; \
		parted \$$DISK -- mklabel gpt; \
		parted \$$DISK -- mkpart primary 512MB -8GB; \
		parted \$$DISK -- mkpart primary linux-swap -8GB 100\%; \
		parted \$$DISK -- mkpart ESP fat32 1MB 512MB; \
		parted \$$DISK -- set 3 esp on; \
		sleep 1; \
		mkfs.ext4 -L nixos \$${DISK}\$${SEP}1; \
		mkswap -L swap \$${DISK}\$${SEP}2; \
		mkfs.fat -F 32 -n boot \$${DISK}\$${SEP}3; \
		sleep 1; \
		mount /dev/disk/by-label/nixos /mnt; \
		mkdir -p /mnt/boot; \
		mount /dev/disk/by-label/boot /mnt/boot; \
		nixos-generate-config --root /mnt; \
		echo 'nameserver 8.8.8.8' > /etc/resolv.conf; \
		sed --in-place '/system\.stateVersion = .*/a \
			nix.package = pkgs.nixVersions.latest;\n \
			nix.extraOptions = \"experimental-features = nix-command flakes\";\n \
			services.openssh.enable = true;\n \
			services.openssh.settings.PasswordAuthentication = true;\n \
			services.openssh.settings.PermitRootLogin = \"yes\";\n \
			users.users.root.initialPassword = \"root\";\n \
		' /mnt/etc/nixos/configuration.nix; \
		nixos-install --no-root-passwd && reboot; \
	"

# After bootstrap0, the VM reboots into a minimal NixOS. Run this to
# copy our config and apply the full configuration.
vm/bootstrap:
	NIXUSER=root $(MAKE) vm/copy
	NIXUSER=root $(MAKE) vm/secrets
	NIXUSER=root $(MAKE) vm/switch
	@echo ""
	@echo "Switch complete. The VM IP may have changed."
	@echo "Find the new IP from the VM console, then run:"
	@echo "  export NIXADDR=<new-ip>"
	@echo "  make vm/secrets-user"
	@echo "  ssh bpinto@\$$NIXADDR sudo reboot"

# Copy the Nix configurations into the VM.
vm/copy:
	rsync -av -e 'ssh $(SSH_OPTIONS) -p$(NIXPORT)' \
		--exclude='.git/' \
		--rsync-path="sudo rsync" \
		$(MAKEFILE_DIR)/ $(NIXUSER)@$(NIXADDR):/nix-config

# Copy system-level secrets into the VM (before vm/switch, user may not exist yet).
vm/secrets:
	rsync -av -e 'ssh $(SSH_OPTIONS) -p$(NIXPORT)' \
		$(HOME)/.ssh/nixos_vm.pub $(HOME)/.ssh/nixos_vm.age $(NIXUSER)@$(NIXADDR):/etc/ssh/
	ssh $(SSH_OPTIONS) -p$(NIXPORT) $(NIXUSER)@$(NIXADDR) "bash -c 'sudo chmod 600 /etc/ssh/nixos_vm.age'"

# Copy user-level secrets into the VM (after vm/switch, user exists).
vm/secrets-user:
	ssh $(SSH_OPTIONS) -p$(NIXPORT) $(NIXUSER)@$(NIXADDR) "bash -c '\
		sudo mkdir -p /home/bpinto/.ssh && \
		sudo chown bpinto:users /home/bpinto/.ssh && \
		sudo chmod 700 /home/bpinto/.ssh \
	'"
	rsync -av -e 'ssh $(SSH_OPTIONS) -p$(NIXPORT)' \
		--rsync-path='sudo rsync' \
		$(HOME)/.ssh/nixos_vm.pub $(HOME)/.ssh/nixos_vm.age \
		$(HOME)/.ssh/github $(HOME)/.ssh/github.pub \
		$(NIXUSER)@$(NIXADDR):/home/bpinto/.ssh/
	ssh $(SSH_OPTIONS) -p$(NIXPORT) $(NIXUSER)@$(NIXADDR) "bash -c '\
		sudo chown bpinto:users /home/bpinto/.ssh/nixos_vm.pub /home/bpinto/.ssh/nixos_vm.age \
			/home/bpinto/.ssh/github /home/bpinto/.ssh/github.pub && \
		sudo chmod 600 /home/bpinto/.ssh/nixos_vm.age /home/bpinto/.ssh/github \
	'"

# Run nixos-rebuild switch. This does NOT copy files so you have to run vm/copy before.
# Note: SSH may disconnect when sshd restarts during switch. This is expected.
# ServerAliveInterval ensures the connection drops quickly instead of hanging.
vm/switch:
	ssh $(SSH_OPTIONS) -p$(NIXPORT) -o ServerAliveInterval=5 -o ServerAliveCountMax=2 \
		$(NIXUSER)@$(NIXADDR) "bash -c '\
		echo nameserver 8.8.8.8 | sudo tee /etc/resolv.conf > /dev/null && \
		sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --flake /nix-config#${NIXNAME} \
	'" || true
