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
sudo ln -sf $PWD/etc/portage/package.use /etc/portage/

# Environment variables per package
sudo ln -sf $PWD/etc/portage/package.env /etc/portage/
sudo ln -sf $PWD/etc/portage/env /etc/portage/

# Custom ebuilds
sudo ln -sf $PWD/usr/local/portage /usr/local/

# Custom patches
sudo ln -sf $PWD/etc/portage/patches /etc/portage/

# Overlay configuration
sudo ln -sf $PWD/etc/portage/repos.conf /etc/portage/

###########################################################
# Power management configuration
###########################################################

# i3lock script
sudo ln -sf $PWD/usr/local/bin/lock /usr/local/bin/lock

# Autolock service
sudo cp $PWD/etc/systemd/system/auto-lock@.service /etc/systemd/system/
sudo systemctl enable auto-lock@$user

# Delayed hibernation service
sudo cp $PWD/etc/systemd/system/suspend-to-hibernate.service /etc/systemd/system/
sudo systemctl enable suspend-to-hibernate

# Fix wakeup after suspending
sudo ln -sf $PWD/etc/udev/rules.d/90-hxc_sleep.rules /etc/udev/rules.d/

###########################################################
# X configuration
###########################################################

# Start configuration
ln -sf $PWD/.xinitrc ~/.xinitrc

# User configuration
ln -sf $PWD/.Xresources ~/.Xresources

# Global configuration
sudo ln -sf $PWD/etc/X11/xorg.conf /etc/X11/
sudo ln -sf $PWD/etc/X11/xorg.conf.d  /etc/X11/

# Wallpaper
sudo ln -sf $PWD/.wallpaper.jpg ~/.wallpaper.jpg

###########################################################
# Font configuration
###########################################################

# Disable every font configuration
for config in $(sudo eselect fontconfig list |grep \* | awk {'print $5 $2'} | tail -n +2); do
  sudo eselect fontconfig disable $config
done

# Enable infinality
sudo eselect fontconfig enable 52-infinality.conf

# User configuration
sudo eselect fontconfig enable 50-user.conf
ln -sf $PWD/.config/fontconfig/fonts.conf ~/.config/fontconfig/

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
sudo ln -sf $PWD/etc/minidlna.conf /etc/

###########################################################
# Newsbeuter configuration
###########################################################

# Configuration files
ln -sf $PWD/.config/newsbeuter ~/.config/

# Manually create XDG data directory until a new version is released:
# https://github.com/akrennmair/newsbeuter/issues/245
mkdir -p ~/.local/share/newsbeuter

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
