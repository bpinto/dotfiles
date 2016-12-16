#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

###########################################################
# X configuration
###########################################################

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
