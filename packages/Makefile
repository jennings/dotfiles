.PHONY: all
all:
	@echo "targets: install dotfiles brew"

.PHONY: install
install: dotfiles brew

.PHONY: clean
clean: brew-purge

.PHONY: brew
brew: Brewfile.lock.json brew-clean
Brewfile.lock.json: Brewfile
	brew bundle install
	touch Brewfile.lock.json

.PHONY: brew-clean
brew-clean:
	brew cleanup

.PHONY: brew-purge
brew-purge:
	brew bundle cleanup
	@confirm && brew bundle cleanup -f
