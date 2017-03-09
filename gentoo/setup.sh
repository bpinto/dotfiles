#!/usr/bin/env bash

user=$(whoami)

# Ask for the administrator password upfront
sudo -v

###########################################################
# Kernel configuration
###########################################################

# File is replaced when using `menuconfig`, so we need to
# remember to copy the config file here after changing it.
sudo cp $PWD/usr/src/linux/.config /usr/src/linux/

# ALSA (sound) configuration
sudo cp $PWD/etc/modprobe.d/alsa.conf /etc/modprobe.d/

# Grub configuration
sudo ln -sf $PWD/etc/default/grub /etc/default/

###########################################################
# Gentoo configuration
###########################################################

# Installed packages
sudo ln -sf $PWD/var/lib/portage/world /var/lib/portage/world

# Global configuration
sudo ln -sf $PWD/etc/portage/make.conf /etc/portage/

# Per package configuration
sudo ln -sf $PWD/etc/portage/package.accept_keywords /etc/portage/
sudo ln -sf $PWD/etc/portage/package.mask /etc/portage/
sudo ln -sf $PWD/etc/portage/package.unmask /etc/portage/
sudo ln -sf $PWD/etc/portage/package.use /etc/portage/

# Environment variables per package
sudo ln -sf $PWD/etc/portage/package.env /etc/portage/
sudo ln -sf $PWD/etc/portage/env /etc/portage/

# Custom ebuilds
sudo ln -sf $PWD/usr/local/portage /usr/local/

# Custom patches
#sudo ln -sf $PWD/etc/portage/patches /etc/portage/

# Overlay configuration
sudo ln -sf $PWD/etc/portage/repos.conf /etc/portage/

###########################################################
# Bluetooth configuration
###########################################################

# Configure pulseaudio
sudo ln -sf $PWD/etc/pulse/default.pa /etc/pulse/

# Configure bluetooth
sudo cp $PWD/etc/bluetooth/main.conf /etc/bluetooth/

###########################################################
# Font configuration
###########################################################

# Configure console font
sudo cp $PWD/etc/vconsole.conf /etc/

###########################################################
# Power management configuration
###########################################################

# Copy script
sudo ln -sf $PWD/usr/local/bin/lock /usr/local/bin/
sudo ln -sf $PWD/usr/local/bin/manual-powertop /usr/local/bin/

# Autolock service
sudo cp $PWD/etc/systemd/system/auto-lock@.service /etc/systemd/system/
sudo systemctl enable auto-lock@$user

# Delayed hibernation service
sudo cp $PWD/etc/systemd/system/suspend-to-hibernate.service /etc/systemd/system/
sudo systemctl enable suspend-to-hibernate

# Powertop service
sudo cp $PWD/etc/systemd/system/powertop.service /etc/systemd/system/
sudo systemctl enable powertop

###########################################################
# Wireless configuration
###########################################################

# Enable services
sudo systemctl enable systemd-networkd
sudo systemctl enable systemd-resolved
sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

# Enable wifi
sudo cp $PWD/etc/systemd/network/wireless.network /etc/systemd/network/
sudo systemctl enable wpa_supplicant@wlan0 # Must be configured at /etc/wpa_supplicant/wpa_supplicant-wlan0.conf

###########################################################
# X configuration
###########################################################

# Start configuration
ln -sf $PWD/.xinitrc ~/.xinitrc

# User configuration
ln -sf $PWD/.Xresources ~/.Xresources

# Global configuration
#sudo ln -sf $PWD/etc/X11/xorg.conf /etc/X11/
sudo ln -sf $PWD/etc/X11/xorg.conf.d  /etc/X11/

# Wallpaper
sudo ln -sf $PWD/.wallpaper.jpg ~/.wallpaper.jpg

###########################################################
# Fish configuration
###########################################################

ln -sf $PWD/../.config/fish ~/.config/
ln -sf $PWD/../.config/omf ~/.config/

###########################################################
# Git configuration
###########################################################
ln -sf $PWD/../.gitconfig ~/
ln -sf $PWD/../.gitignore ~/
ln -sf $PWD/../.gitmessage ~/
ln -sf $PWD/../.git_template ~/

###########################################################
# i3 configuration
###########################################################

# i3 configuration
ln -sf $PWD/.config/i3 ~/.config/

# Polybar configuration
ln -sf $PWD/.config/polybar ~/.config/

###########################################################
# Minidlna configuration
###########################################################

# Configuration files
#sudo ln -sf $PWD/etc/minidlna.conf /etc/

###########################################################
# MPV configuration
###########################################################

# Configuration files
ln -sf $PWD/.config/mpv/mpv.conf ~/.config/mpv/

###########################################################
# Neovim configuration
###########################################################

ln -sf $PWD/../.config/nvim ~/.config/

###########################################################
# Newsbeuter configuration
###########################################################

# Configuration files
ln -sf $PWD/.config/newsbeuter ~/.config/

###########################################################
# Redshift configuration
###########################################################

# Configuration files
ln -sf $PWD/.config/redshift.conf ~/.config/

# Enable autostart
systemctl --user enable redshift

# Fix builtin systemd service
mkdir -p ~/.config/systemd/user/redshift.service.d
ln -sf $PWD/.config/systemd/user/redshift.service.d/custom.conf ~/.config/systemd/user/redshift.service.d/

###########################################################
# Termite configuration
###########################################################

ln -sf $PWD/.config/termite/config ~/.config/termite/

###########################################################
# Weechat configuration
###########################################################

# Configuration files
ln -sf $PWD/.weechat ~/

###########################################################
# Youtube-dl configuration
###########################################################

# Configuration files
ln -sf $PWD/.config/youtube-dl ~/.config/
