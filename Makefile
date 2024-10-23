all: example docs-build lint-lua ## Builds examples, docs and runs lints.

example: ## Generates hyprlua examples
	@bin/hyprlua -c examples/hyprland.lua -o examples/hyprland.conf

docs-build: ## Generates documentation
	@ldoc src/

lint: lint-lua ## Lint all files

lint-lua:
	@find . -name "*.lua" -type f -exec stylua {} \;

release: ## Releases Hyprlua on Luarocks
	@luarocks upload hyprlua.rockspec

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: help
.DEFAULT_GOAL := help
