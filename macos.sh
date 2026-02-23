#!/usr/bin/env bash

# --- Screenshots ---
mkdir -p ~/Screenshots
defaults write com.apple.screencapture location ~/Screenshots

# --- Dock ---
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock expose-group-apps -bool true
defaults delete com.apple.dock persistent-apps
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-br-corner -int 0

# --- Finder ---
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"mac
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.finder FinderSpawnTab -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# --- Spaces (Displays) ---
defaults write com.apple.spaces spans-displays -bool true

# --- Keyboard ---
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
defaults write -g ApplePressAndHoldEnabled -bool false

# --- Text Input ---
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write com.apple.TextInputMenu visible -bool false

# --- Window Manager ---
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false
defaults write com.apple.WindowManager EnableStageManagerClickToShowDesktop -bool true
defaults write com.apple.WindowManager GloballyEnabled -bool false

# --- Appearance ---
defaults write -g AppleInterfaceStyleSwitchesAutomatically -bool true

# --- Hotkeys ---
# Symbolic Hotkeys Being Disabled:
# 60: Select the previous input source (default: ^Space)
# 61: Select next source in input menu (default: ^⌥Space)
# 64: Show Finder search window (default: ⌥⌘Space)
# 65: Show Spotlight search (default: ⌘Space)

/usr/libexec/PlistBuddy -c "Delete :AppleSymbolicHotKeys:60" ~/Library/Preferences/com.apple.symbolichotkeys.plist 2>/dev/null
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:60:enabled bool false" ~/Library/Preferences/com.apple.symbolichotkeys.plist

/usr/libexec/PlistBuddy -c "Delete :AppleSymbolicHotKeys:61" ~/Library/Preferences/com.apple.symbolichotkeys.plist 2>/dev/null
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:61:enabled bool false" ~/Library/Preferences/com.apple.symbolichotkeys.plist

/usr/libexec/PlistBuddy -c "Delete :AppleSymbolicHotKeys:64" ~/Library/Preferences/com.apple.symbolichotkeys.plist 2>/dev/null
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:64:enabled bool false" ~/Library/Preferences/com.apple.symbolichotkeys.plist

/usr/libexec/PlistBuddy -c "Delete :AppleSymbolicHotKeys:65" ~/Library/Preferences/com.apple.symbolichotkeys.plist 2>/dev/null
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:65:enabled bool false" ~/Library/Preferences/com.apple.symbolichotkeys.plist

# --- Apply Changes ---
killall SystemUIServer
killall Dock
killall Finder
killall ControlCenter
killall cfprefsd

# --- Information ---
cat <<EOF
macOS settings applied.

IMPORTANT!
A reboot is required for some of the changes to take effect.
EOF
