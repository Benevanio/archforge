# Contributing to ArchForge

Thanks for considering a contribution to ArchForge! This project favors
small, well-tested, incremental changes over large rewrites.

## Development setup

Requirements:

- Bash 4+
- [ShellCheck](https://github.com/koalaman/shellcheck#installing)

Clone the repository and run the CLI directly from the source tree, no
installation required:

```bash
git clone <repository>
cd archforge
./bin/archforge --help
```

## Project structure

See [`docs/architecture.md`](docs/architecture.md) for a full explanation
of how the codebase is organized.

## Running tests

```bash
make test
# or
bash tests/run_all.sh
```

## Linting

```bash
make lint
```

All shell scripts must pass ShellCheck with no warnings before a PR is
merged. If you believe a specific warning is a false positive, disable it
inline with a comment explaining why (see existing examples in
`core/config.sh` and `tests/helpers.sh`) rather than disabling it globally.

## Adding a new architecture template

See [`docs/templates.md`](docs/templates.md) for a full walkthrough. In
short: add a new directory under `templates/`, that's it — no core code
needs to change for `archforge list` or `archforge info` to pick it up.

## Coding guidelines

- Prefer simplicity over cleverness. This is Bash, not a general-purpose
  application language.
- Quote all variable expansions (`"$VARIABLE"`, not `$VARIABLE`).
- Never use `eval`.
- Keep functions small and focused.
- Every new script must start with `#!/usr/bin/env bash` and, where
  appropriate, `set -euo pipefail`.
- New behavior should come with new tests in `tests/`.
- Run `make check` (lint + test) before opening a PR.

## Commit / PR expectations

- Keep PRs focused on a single change.
- Update `CHANGELOG.md` for user-facing changes.
- Update relevant docs (`README.md`, `docs/`) when behavior changes.

## Reporting bugs / proposing features

Please open an issue describing:

- What you expected to happen.
- What actually happened (include the exact command and output).
- Your OS/Bash version (`bash --version`).

## Code of conduct

Be respectful and constructive. This is a small open source project
maintained on a best-effort basis.
