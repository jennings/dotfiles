#!/bin/bash -euo pipefail

# Sources:
# https://github.com/mathiasbynens/dotfiles/blob/0cd43d175a25c0e13e1e06ab31ccfd9f0169cf73/.macos

# Quit System Preferences so it doesn't override
osascript -e 'tell application "System Preferences" to quit'

###############
# Miscellaneous
###############

# Expand save panel by default
# undo: defaults delete -g NSNavPanelExpandedStateForSaveMode
# undo: defaults delete -g NSNavPanelExpandedStateForSaveMode2
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

# Save to disk (not to iCloud) by default
defaults write -g NSDocumentSaveNewDocumentsToCloud -bool false

#######
# Mouse
#######

# Disable “natural” (Lion-style) scrolling
# undo: defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true
defaults write -g com.apple.swipescrolldirection -bool false

##########
# Keyboard
##########

defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 10

# Repeat keys when held
# undo: defaults delete -g ApplePressAndHoldEnabled
defaults write -g ApplePressAndHoldEnabled -bool false

##########################
# Mission Control and Dock
##########################

# Mission Control animations
# undo: defaults delete com.apple.dock expose-animation-duration
defaults write com.apple.dock expose-animation-duration -float 0.1

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false
