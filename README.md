Dotfiles
========

These are my dotfiles and misellaneous things that live in my home directory.

## Usage

Follows this guide: https://www.atlassian.com/git/tutorials/dotfiles

### Git

```powershell
# Set env var: # DOTFILES_REPO=C:/path/to/dotfiles.git
git clone https://github.com/jennings/dotfiles $env:DOTFILES_REPO --bare

# after checkout, this alias is defined by profile.ps1
function dotfiles { git --git-dir=${env:DOTFILES_REPO} --work-tree=${env:USERPROFILE} $Args }
dotfiles checkout

# hide anything not explicitly added
# this isn't strictly necessary now that .gitignore includes '*'
dotfiles config status.showUntrackedFiles no
```

The alias `dotfiles` is defined in `.zshrc` and `profile.ps1`.

### jj

I'm also using this repository to figure out
[jj](https://github.com/martinvonz/jj).

```powershell
cd
jj init --git https://github.com/jennings/dotfiles
```
