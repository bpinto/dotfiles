#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

###########################################################
# Kernel configuration
###########################################################

sudo ln -sf $PWD/usr/src/linux/.config /usr/src/linux/

###########################################################
# Gentoo configuration
###########################################################

# Global configuration
sudo ln -sf $PWD/portage/make.conf /etc/portage/

# Per package configuration
sudo ln -sf $PWD/portage/package.accept_keywords /etc/portage/
sudo ln -sf $PWD/portage/package.mask /etc/portage/
sudo ln -sf $PWD/portage/package.use /etc/portage/

# Environment variables per package
sudo ln -sf $PWD/portage/package.env /etc/portage/
sudo ln -sf $PWD/portage/env /etc/portage/

# Overlay configuration
sudo ln -sf $PWD/portage/repos.conf /etc/portage/

###########################################################
# X configuration
###########################################################

# Start configuration
ln -sf $PWD/.xinitrc ~/.xinitrc

# User configuration
ln -sf $PWD/.Xresources ~/.Xresources

# Global configuration
sudo ln -sf $PWD/X11/xorg.conf /etc/X11/
sudo ln -sf $PWD/X11/xorg.conf.d/99-libinput-custom-config.conf /etc/X11/xorg.conf.d/

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
# Termite configuration
###########################################################

ln -sf $PWD/.config/termite/config ~/.config/termite/

###########################################################
# Weechat configuration
###########################################################

# Configuration files
ln -sf $PWD/.weechat ~/
