.PHONY: all
all:
	@echo "targets: install dotfiles brew"

.PHONY: install
install: dotfiles brew

.PHONY: clean
clean: brew-clean

.PHONY: dotfiles
dotfiles:
	./setup.sh

.PHONY: vscode
vscode:
	cd vscode && ./sync.sh

.PHONY: brew
brew: Brewfile.lock.json
Brewfile.lock.json: Brewfile
	brew bundle install
	touch Brewfile.lock.json

.PHONY: brew-clean
brew-clean:
	brew bundle cleanup
	@confirm && brew bundle cleanup -f
