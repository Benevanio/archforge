# Development Guide

## Requirements

- Bash 4+ (see [compatibility notes](#compatibility) below)
- [ShellCheck](https://github.com/koalaman/shellcheck#installing)
- `git`
- `make` (optional, but recommended)

## Running from source

No build step is required — Bash scripts run as-is:

```bash
git clone <repository>
cd archforge
./bin/archforge --help
```

## Project layout

See [`architecture.md`](architecture.md) for the full breakdown of
`bin/`, `commands/`, `core/`, and `templates/`.

## Running tests

```bash
make test
# equivalent to:
bash tests/run_all.sh
```

Individual suites can be run directly:

```bash
bash tests/test_list.sh
bash tests/test_info.sh
bash tests/test_init.sh
```

Test conventions:

- Tests live in `tests/test_*.sh` and are auto-discovered by
  `tests/run_all.sh`.
- Shared assertion helpers live in `tests/helpers.sh`
  (`assert_equal`, `assert_contains`, `assert_exit_code`,
  `assert_dir_exists`, `assert_file_not_exists`).
- `init` tests run inside a temporary sandbox directory
  (`setup_sandbox`/`teardown_sandbox`) so they never touch your working
  directory or leave artifacts behind.
- Assertions check both **exit codes** and **actual output/filesystem
  state** — not just "did the command not crash".

## Linting

```bash
make lint
```

This runs `shellcheck` against every script in `bin/`, `core/`,
`commands/`, and `tests/`. The project ships a `.shellcheckrc` that
disables `SC1091` (ShellCheck cannot statically follow ArchForge's
runtime-resolved `source` paths); everything else must pass with zero
warnings.

## `make check`

Runs lint + test together — this is what CI runs, and what you should run
before opening a pull request:

```bash
make check
```

## Testing installation locally

```bash
./install.sh
archforge --help
make uninstall   # clean up afterwards
```

`install.sh` is non-destructive: it will refuse to overwrite an existing
file at the target path that isn't already a symlink it manages.

## Compatibility

| Platform | Status                          |
|----------|-----------------------------------|
| Ubuntu   | Supported, tested in CI            |
| Debian   | Supported (same code path as Ubuntu) |
| WSL      | Supported (detected explicitly by `install.sh`) |
| macOS    | Supported where possible; not covered by CI     |
| Windows (Git Bash) | Supported (detected as `MINGW/MSYS/CYGWIN`) |

Minimum requirement: **Bash 4+**. macOS ships Bash 3.2 by default (due to
licensing), so macOS users may need to install a newer Bash via Homebrew
(`brew install bash`) and ensure it's the one on their `PATH` when running
ArchForge. No feature in the current codebase requires Bash 5+, but this
will be called out explicitly in `CHANGELOG.md` if that ever changes.

## Continuous Integration

`.github/workflows/ci.yml` runs on every push and pull request against
`main`, on `ubuntu-latest`:

1. Install ShellCheck
2. Run ShellCheck against all scripts
3. Run the full test suite
4. Verify the CLI starts (no args → usage + exit code 2)
5. Test `--help`
6. Test `--version`
7. Test `list`
8. Test `info`
9. Test `init` (generate a project and assert its structure)

## Releasing

1. Update `ARCHFORGE_VERSION` in `core/config.sh`.
2. Move the relevant `CHANGELOG.md` section from `[Unreleased]` to a
   dated version heading.
3. Tag the release in Git.

## Coding conventions

See [`CONTRIBUTING.md`](../CONTRIBUTING.md) for the full list. The short
version: quote everything, no `eval`, small functions, one responsibility
per file, and every new behavior needs a test.
