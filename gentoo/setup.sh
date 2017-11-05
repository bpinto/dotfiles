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

# Grub configuration
sudo ln -sf $PWD/etc/default/grub /etc/default/

# Genkernel configuration
sudo ln -sf $PWD/etc/genkernel.conf /etc/

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
# Font configuration
###########################################################

ln -sf $PWD/.config/fontconfig ~/.config/

# Configure console font
sudo cp $PWD/etc/vconsole.conf /etc/

# Copy San Francisco font
sudo cp -rf $PWD/usr/share/fonts/system-san-francisco /usr/share/fonts/

###########################################################
# Power management configuration
###########################################################

# Copy script
#sudo ln -sf $PWD/usr/local/bin/lock /usr/local/bin/
#sudo ln -sf $PWD/usr/local/bin/manual-powertop /usr/local/bin/

# Autolock service
#sudo cp $PWD/etc/systemd/system/auto-lock@.service /etc/systemd/system/
#sudo systemctl enable auto-lock@$user

# Delayed hibernation service
sudo cp $PWD/etc/systemd/system/suspend.target /etc/systemd/system/
sudo cp $PWD/etc/systemd/system/suspend-to-hibernate.service /etc/systemd/system/
sudo systemctl enable suspend-to-hibernate

# Powertop service
#sudo cp $PWD/etc/systemd/system/powertop.service /etc/systemd/system/
#sudo systemctl enable powertop

###########################################################
# SSH configuration
###########################################################

# SSH agent auto-start service
mkdir -p ~/.config/systemd/user
systemctl --user enable $PWD/.config/systemd/user/ssh-agent.service

###########################################################
# Time configuration
###########################################################

sudo timedatectl set-timezone Europe/Lisbon
sudo timedatectl set-ntp true

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
# Docker configuration
###########################################################

sudo usermod -aG docker $user

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
# MPV configuration
###########################################################

# Configuration files
ln -sf $PWD/.config/mpv/mpv.conf ~/.config/mpv/

###########################################################
# Neovim configuration
###########################################################

ln -sf $PWD/../.config/nvim ~/.config/

# Create backup folder
mkdir -p ~/.local/share/nvim/backup

# Install vim-plug
if [[ ! -e ~/.local/share/nvim/site/autoload/plug.vim ]]; then
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

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
# Sandbox
###########################################################

if ! id -u browser > /dev/null 2>&1; then
  # Sandbox Firefox
  sudo ./sandbox_user.sh www-client/firefox browser /home/browser $user

  # Firefox configured to run in sandbox mode
  sudo ln -sf $PWD/usr/local/bin/firefox /usr/local/bin/
fi

###########################################################
# Spotify configuration
###########################################################

# HiDPI support
#sudo ln -sf $PWD/usr/local/bin/spotify /usr/local/bin/

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
