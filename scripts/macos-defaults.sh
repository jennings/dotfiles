#!/bin/bash -euo pipefail

# Mission Control animations
# undo: defaults delete com.apple.dock expose-animation-duration
defaults write com.apple.dock expose-animation-duration -float 0.1

# Repeat keys when held
# undo: defaults delete -g ApplePressAndHoldEnabled
defaults write -g ApplePressAndHoldEnabled -bool false
