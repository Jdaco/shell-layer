LAYER=shell-private
INSTALL_PATH=~/.emacs.d/private/$(LAYER)

.PHONY: help
help: ## Show help message
	@grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:[[:blank:]]*\(##\)[[:blank:]]*/\1/' | column -s '##' -t

.PHONY: install
install: ## Link this layer to your spacemacs config directory
	@ln --verbose --symbolic $(realpath $(LAYER)) $(INSTALL_PATH)

.PHONY: uninstall
uninstall: ## Uninstall this layer
	@rm -v $(INSTALL_PATH)
