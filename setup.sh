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
# Bat configuration
###########################################################

ln -sf $PWD/.config/bat ~/.config/

###########################################################
# Chrome configuration
###########################################################

# Prevent left and right swipe through history
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false

###########################################################
# Elvish configuration
###########################################################

mkdir -p ~/.elvish

# Config files
ln -sf $PWD/.elvish/rc.elv ~/.elvish/

# Plugins
ln -sf $PWD/.elvish/lib/cliniko.elv ~/.elvish/lib/
ln -sf $PWD/.elvish/lib/docker.elv ~/.elvish/lib/
ln -sf $PWD/.elvish/lib/node.elv ~/.elvish/lib/
ln -sf $PWD/.elvish/lib/prompt.elv ~/.elvish/lib/

###########################################################
# Fish configuration
###########################################################

ln -sf $PWD/.config/fish ~/.config/

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
# Kitty configuration
###########################################################

# Fix config file not loading for kitty: kitty/issues/1375
launchctl setenv KITTY_CONFIG_DIRECTORY $HOME/.config/kitty/

# Config files
ln -sf $PWD/.config/kitty ~/.config/

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

# Install global projectionist file
ln -sf $PWD/.config/projections.json ~/.config/

###########################################################
# Safari configuration
###########################################################

# Enable Develop Menu and Web Inspector
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true && \
defaults write com.apple.Safari IncludeDevelopMenu -bool true && \
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true && \
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true && \
defaults write -g WebKitDeveloperExtras -bool true

###########################################################
# macOS configuration
###########################################################

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Set language and text formats
# Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
defaults write NSGlobalDomain AppleLanguages -array "en" "pt-br"
defaults write NSGlobalDomain AppleLocale -string "en_PT@currency=EUR"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

# --
# -- Dock
# --

# Auto Rearrange Spaces Based on Most Recent Use (Disable)
defaults write com.apple.dock mru-spaces -bool false

# --
# -- Finder
# --

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Set $HOME as the default location for new Finder windows
# For other paths, see https://github.com/mathiasbynens/dotfiles/pull/285#issuecomment-31608378
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Show icons for external hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Show item info near icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Show item info to the right of the icons on the desktop
/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Increase grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

# Increase the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool true \
  OpenWith -bool true \
  Privileges -bool true

# --
# -- Keyboard
# --

# Enable Key Repeat
defaults write -g ApplePressAndHoldEnabled -bool false

# Key Repeat rate
defaults write NSGlobalDomain KeyRepeat -int 3
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Enable US layout
defaults read com.apple.HIToolbox | grep -q 252 || \
  defaults write com.apple.HIToolbox AppleEnabledInputSources -array-add '<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>252</integer><key>KeyboardLayout Name</key><string>ABC</string></dict>'

# Enable PT-BR layout
defaults read com.apple.HIToolbox | grep -q 72 || \
  defaults write com.apple.HIToolbox AppleEnabledInputSources -array-add '<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>72</integer><key>KeyboardLayout Name</key><string>Brazilian - Pro</string></dict>'

# --
# -- Printer
# --

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# --
# -- Trackpad
# --

# Enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Dock" "Finder" "Google Chrome" "Safari"; do
  killall "${app}" &> /dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."
