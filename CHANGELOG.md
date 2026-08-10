# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - Unreleased

### Added

- Initial CLI (`bin/archforge`) with `init`, `list`, `info`, `--help`, and
  `--version` commands.
- Generic, filesystem-driven template discovery system
  (`templates/<architecture>/`), requiring no core code changes to add a
  new architecture.
- Three built-in templates: `clean-ddd` (Clean Architecture + DDD), `mvc`,
  and `mmvc`.
- Project name and architecture validation, including path-traversal
  protection.
- Centralized logging (`core/logger.sh`) with optional color support.
- Centralized exit codes (`core/config.sh`).
- Bash test suite covering `list`, `info`, and `init` (including failure
  paths: unknown architecture, existing directory, invalid names).
- `install.sh` for non-destructive, symlink-based installation with
  OS detection and PATH guidance.
- `Makefile` with `test`, `lint`, `check`, `install`, and `uninstall`
  targets.
- GitHub Actions CI pipeline running ShellCheck and the full test suite.
- Documentation: `docs/architecture.md`, `docs/templates.md`,
  `docs/development.md`, and per-template usage examples in `examples/`.
