SHELL := /usr/bin/env bash

PREFIX ?= /usr/local
BIN_DIR := $(PREFIX)/bin
INSTALL_TARGET := $(BIN_DIR)/archforge

.PHONY: test lint install uninstall check help

help:
	@echo "ArchForge - available targets:"
	@echo ""
	@echo "  make test       Run the test suite"
	@echo "  make lint       Run ShellCheck against all scripts"
	@echo "  make check      Run lint + test"
	@echo "  make install    Install archforge via install.sh"
	@echo "  make uninstall  Remove the installed archforge symlink"

test:
	@bash tests/run_all.sh

lint:
	@command -v shellcheck >/dev/null 2>&1 || { \
		echo "shellcheck is not installed. See: https://github.com/koalaman/shellcheck#installing"; \
		exit 1; \
	}
	@shellcheck bin/archforge core/*.sh commands/*.sh tests/*.sh

check: lint test

install:
	@./install.sh

uninstall:
	@if [ -L "$(INSTALL_TARGET)" ] || [ -f "$(INSTALL_TARGET)" ]; then \
		rm -f "$(INSTALL_TARGET)"; \
		echo "Removed $(INSTALL_TARGET)"; \
	else \
		echo "$(INSTALL_TARGET) not found, nothing to do."; \
	fi
