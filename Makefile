all: example docs-build lint-lua ## Builds examples, docs and runs lints.

clean: ## Clear build files
	@rm -rf build .cache

build: clean ## Builds Hyprlua
	@mkdir build
	# @(cd build && cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON .. && make -j4)
	@cd build &&\
		cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON .. &&\
		make -j4

example: ## Generates hyprlua examples
	@bin/hyprlua -c examples/hyprland.lua -o examples/hyprland.conf

docs-build: ## Generates documentation
	@ldoc --config config.ld --dir docs/ runtime/

lint: lint-lua ## Lint all files

lint-lua:
	@find . -name "*.lua" -type f -exec stylua {} \;

release: ## Releases Hyprlua on Luarocks
	@luarocks upload hyprlua.rockspec

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: help clean release lint-lua lint docs-build example
.DEFAULT_GOAL := help
