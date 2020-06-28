.PHONY: all
all:
	@echo "targets: install dotfiles brew"

.PHONY: install
install: dotfiles brew

.PHONY: dotfiles
dotfiles:
	./setup.sh

.PHONY: brew
brew: Brewfile.lock.json
Brewfile.lock.json: Brewfile
	brew bundle install
	touch Brewfile.lock.json
