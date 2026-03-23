{
  system.defaults = {
    # --
    # -- Dock
    # --

    dock = {
      # Auto Rearrange Spaces Based on Most Recent Use (Disable)
      mru-spaces = false;

      autohide = true;
      show-recents = false;
    };

    # --
    # -- Finder
    # --

    finder = {
      # When performing a search, search the current folder by default
      FXDefaultSearchScope = "SCcf";

      # Use list view in all Finder windows by default
      # Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
      FXPreferredViewStyle = "Nlsv";

      # Set $HOME as the default location for new Finder windows
      # For other paths, see https://github.com/mathiasbynens/dotfiles/pull/285#issuecomment-31608378
      NewWindowTarget = "Home";

      # Show status bar
      ShowStatusBar = true;

      # Show path bar
      ShowPathbar = true;

      # Display full POSIX path as Finder window title
      _FXShowPosixPathInTitle = true;

      # Keep folders on top when sorting by name
      _FXSortFoldersFirst = true;

      # Show icons for external hard drives, servers, and removable media on the desktop
      ShowExternalHardDrivesOnDesktop = true;
      ShowHardDrivesOnDesktop = false;
      ShowMountedServersOnDesktop = true;
      ShowRemovableMediaOnDesktop = true;
    };

    # Avoid creating .DS_Store files on network volumes
    CustomUserPreferences."com.apple.desktopservices" = {
      DSDontWriteNetworkStores = true;
    };

    # Expand the following File Info panes:
    # "General", "Open with", and "Sharing & Permissions"
    CustomUserPreferences."com.apple.finder" = {
      FXInfoPanesExpanded = {
        General = true;
        OpenWith = true;
        Privileges = true;
      };
    };

    # --
    # -- Global
    # --

    NSGlobalDomain = {
      # Show all filename extensions
      AppleShowAllExtensions = true;

      # Enable Key Repeat
      ApplePressAndHoldEnabled = false;

      # Key Repeat rate
      InitialKeyRepeat = 15;
      KeyRepeat = 3;

      # Expand save panel by default
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;

      # Expand print panel by default
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;

      # Enable tap to click for this user and for the login screen
      "com.apple.mouse.tapBehavior" = 1;
    };

    # --
    # -- Trackpad
    # --

    # Enable tap to click for this user and for the login screen
    trackpad.Clicking = true;

    # --
    # -- Printer
    # --

    # Automatically quit printer app once the print jobs complete
    CustomUserPreferences."com.apple.print.PrintingPrefs" = {
      "Quit When Finished" = true;
    };

    # --
    # -- Chrome
    # --

    # Prevent left and right swipe through history
    CustomUserPreferences."com.google.Chrome" = {
      AppleEnableSwipeNavigateWithScrolls = false;
    };

  };

  system.activationScripts.postActivation.text = ''
    # --
    # -- Finder
    # --

    # Show item info near icons on the desktop and in other icon views
    PLIST="/Users/bpinto/Library/Preferences/com.apple.finder.plist"
    sudo -u bpinto /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" "$PLIST" 2>/dev/null || true
    sudo -u bpinto /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" "$PLIST" 2>/dev/null || true
    sudo -u bpinto /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" "$PLIST" 2>/dev/null || true

    # Show item info to the right of the icons on the desktop
    sudo -u bpinto /usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" "$PLIST" 2>/dev/null || true

    # Enable snap-to-grid for icons on the desktop and in other icon views
    sudo -u bpinto /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" "$PLIST" 2>/dev/null || true
    sudo -u bpinto /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" "$PLIST" 2>/dev/null || true
    sudo -u bpinto /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" "$PLIST" 2>/dev/null || true

    # Increase grid spacing for icons on the desktop and in other icon views
    sudo -u bpinto /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" "$PLIST" 2>/dev/null || true
    sudo -u bpinto /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" "$PLIST" 2>/dev/null || true
    sudo -u bpinto /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" "$PLIST" 2>/dev/null || true

    # Increase the size of icons on the desktop and in other icon views
    sudo -u bpinto /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" "$PLIST" 2>/dev/null || true
    sudo -u bpinto /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" "$PLIST" 2>/dev/null || true
    sudo -u bpinto /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" "$PLIST" 2>/dev/null || true

    # --
    # -- Locale
    # --

    # Set language and text formats
    sudo -u bpinto defaults write NSGlobalDomain AppleLanguages -array "en" "pt-br"
    sudo -u bpinto defaults write NSGlobalDomain AppleLocale -string "en_001@currency=eur;rg=ptzzzz"
    sudo -u bpinto defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
    sudo -u bpinto defaults write NSGlobalDomain AppleMetricUnits -bool true

    # Turn off font smoothing: https://tonsky.me/blog/monitors/
    sudo -u bpinto defaults -currentHost write -g AppleFontSmoothing -int 0

    # --
    # -- Trackpad
    # --

    # Enable tap to click for this user and for the login screen
    sudo -u bpinto defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

    # --
    # -- Safari
    # --

    # Enable Develop Menu and Web Inspector
    sudo -u bpinto defaults write com.apple.Safari.SandboxBroker ShowDevelopMenu -bool true

    # --
    # -- Keyboard
    # --

    # Install PT to US keyboard remap (EN language)
    sudo -u bpinto mkdir -p "/Users/bpinto/Library/Keyboard Layouts/"
    sudo -u bpinto cp -R /Users/bpinto/src/dotfiles/users/shared/dotfiles/pt-us.en.keymap.bundle "/Users/bpinto/Library/Keyboard Layouts/"

    # Install PT to US keyboard remap (PT language)
    sudo -u bpinto cp -R /Users/bpinto/src/dotfiles/users/shared/dotfiles/pt-us.pt.keymap.bundle "/Users/bpinto/Library/Keyboard Layouts/"
  '';
}
