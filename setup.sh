#!/usr/bin/env bash

###########################################################
# Brew configuration
###########################################################

brew analytics off
brew bundle

###########################################################
# General configuration
###########################################################

# Create $XDG_CONFIG_HOME directory
mkdir -p ~/.config

# Create $XDG_DATA_HOME directory
mkdir -p ~/.local/share

###########################################################
# Alacritty configuration
###########################################################

ln -sf $PWD/.config/alacritty ~/.config/

###########################################################
# Elvish configuration
###########################################################

mkdir -p ~/.elvish

# Config files
ln -sf $PWD/.elvish/rc.elv ~/.elvish/

# Plugins
ln -sf $PWD/.elvish/lib/cliniko.elv ~/.elvish/lib/
ln -sf $PWD/.elvish/lib/prompt.elv ~/.elvish/lib/

###########################################################
# Git configuration
###########################################################

ln -sf $PWD/.gitconfig ~/
ln -sf $PWD/.gitignore ~/
ln -sf $PWD/.gitmessage ~/
ln -sf $PWD/.git_template ~/

###########################################################
# GPG configuration
###########################################################

mkdir -p ~/.gnupg
chmod 700 ~/.gnupg

ln -sf $PWD/.gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
ln -sf $PWD/.gnupg/gpg.conf ~/.gnupg/gpg.conf

###########################################################
# macOS configuration
###########################################################

# --Dock--
# Auto Rearrange Spaces Based on Most Recent Use (Disable)
defaults write com.apple.dock mru-spaces -bool false

# --Keyboard--
# Enable Key Repeat
defaults write -g ApplePressAndHoldEnabled -bool false
# Key Repeat rate
defaults write NSGlobalDomain KeyRepeat -int 3
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# --Safari--
# Enable Develop Menu and Web Inspector
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true && \
defaults write com.apple.Safari IncludeDevelopMenu -bool true && \
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true && \
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true && \
defaults write -g WebKitDeveloperExtras -bool true

###########################################################
# Neovim configuration
###########################################################

ln -sf $PWD/.config/nvim ~/.config/

# Create backup folder
mkdir -p ~/.local/share/nvim/backup

# Install vim-plug
if [[ ! -e ~/.local/share/nvim/site/autoload/plug.vim ]]; then
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Dock" "Safari"; do
  killall "${app}" &> /dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."
