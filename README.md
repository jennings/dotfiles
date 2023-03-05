Dotfiles
========

These are my dotfiles and misellaneous things that live in my home directory.

## Usage

Follows this guide: https://www.atlassian.com/git/tutorials/dotfiles

```
# Set an env var: DOTFILES_REPO=C:/path/to/dotfiles.git
git clone https://github.com/jennings/dotfiles $env:DOTFILES_REPO --bare

# restart the terminal to load the `dotfiles` alias

# hide anything not explicitly added
dotfiles config status.showUntrackedFiles no
```

The alias `dotfiles` is defined in `.zshrc` and `profile.ps1`.
