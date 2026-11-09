# ArchForge

**Forge your architecture.**

CLI for generating software projects from architecture patterns and
templates.

<!--
  Badge URLs below use placeholders. Once this project has a real GitHub
  repository, replace OWNER/REPO throughout this file (and point the CI
  badge at the actual workflow file) to make these badges live.
-->

[![CI](https://img.shields.io/badge/CI-configured-blue)](.github/workflows/ci.yml)
[![ShellCheck](https://img.shields.io/badge/ShellCheck-passing-brightgreen)](https://www.shellcheck.net/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-0.1.0-blue)](CHANGELOG.md)

---

## What is ArchForge?

ArchForge is a **CLI scaffolding tool** for creating software projects
from well-known architecture patterns. Instead of manually creating
folders for Clean Architecture, MVC, or MMVC every time you start a new
service, you run one command and get a consistent, documented project
skeleton.

```bash
archforge init my-api --arch clean-ddd
```

## Problem it solves

Teams that adopt an architecture pattern (Clean Architecture, MVC, DDD,
etc.) usually end up either:

- copy-pasting a folder structure from a previous project, or
- re-explaining the same layer responsibilities in every project's README.

ArchForge centralizes both: a single source of truth for the folder
structure **and** the documentation of what each layer is for, versioned
and reusable across every new project you start.

## Installation

### Linux / macOS / WSL / Git Bash

```bash
git clone <repository>
cd archforge
./install.sh
```

### Windows (PowerShell)

`.sh` files don't run from PowerShell or cmd.exe — running `.\install.sh`
there does nothing. Use the PowerShell installer instead (requires
[Git for Windows](https://git-scm.com/download/win), which provides Git Bash):

```powershell
git clone <repository>
cd archforge
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

`install.ps1` creates an `archforge.cmd` shim in
`%LocalAppData%\ArchForge\bin` (running the CLI through Git Bash) and adds
that directory to your user `PATH`. Open a new terminal afterwards, then
run `archforge --help`.

`install.sh` will:

1. Detect your OS (Linux, WSL, macOS, or Git Bash on Windows).
2. Verify Bash 4+ is available.
3. Install `bin/archforge` into a writable directory on your system
  (symlink when available, launcher wrapper otherwise)
   (`/usr/local/bin` if writable, otherwise `~/.local/bin`).
4. Tell you explicitly if that directory isn't already on your `PATH`.

It never overwrites existing files and never modifies your shell profile
automatically.

### Requirements

- Bash 4+
- Standard POSIX utilities (`cp`, `mkdir`, `rm`, `find`) — no other
  runtime dependencies

## Usage

```bash
archforge --help
archforge --version

archforge list
archforge info <architecture>
archforge init <project-name> --arch <architecture>
```

## Available architectures

| Architecture | Description |
|---|---|
| `clean-ddd` | Clean Architecture + Domain-Driven Design |
| `mvc` | Classic Model-View-Controller |
| `mmvc` | MVC with an explicit View-Model layer |

Run `archforge list` to see architectures discovered from your local
`templates/` directory (this will include any custom templates you add),
and `archforge info <architecture>` for details on a specific one.

## Examples

```bash
$ archforge list
Available architectures:

  clean-ddd
  mmvc
  mvc
```

```bash
$ archforge info clean-ddd
Architecture: Clean Architecture + DDD

Description:
Domain-centric architecture based on Clean Architecture and Domain-Driven Design principles.

Layers:

  domain
  application
  infrastructure
  presentation

Principles:

  Dependency Inversion
  Separation of Concerns
  Domain Isolation
```

```bash
$ archforge init my-api --arch clean-ddd
[INFO] Creating project 'my-api' with architecture 'clean-ddd'...
[SUCCESS] Project 'my-api' created successfully.
```

```text
my-api/
├── src/
│   ├── domain/
│   ├── application/
│   ├── infrastructure/
│   └── presentation/
└── tests/
```

More full walkthroughs, including MVC and MMVC, are in
[`examples/`](examples).

## Project structure

```text
archforge/
├── bin/archforge          # CLI entrypoint
├── commands/                # init.sh, list.sh, info.sh
├── core/                     # config, logger, validation, filesystem, template
├── templates/                # clean-ddd/, mvc/, mmvc/
├── tests/                     # Bash test suite
├── docs/                       # architecture.md, templates.md, development.md
├── examples/                    # per-template usage walkthroughs
├── .github/workflows/ci.yml
├── install.sh
└── Makefile
```

See [`docs/architecture.md`](docs/architecture.md) for the full internal
design.

## Creating new templates

Adding a new architecture (e.g. `hexagonal`) requires **zero changes** to
the CLI core — just add a directory under `templates/` with an
`archforge.conf` metadata file. See
[`docs/templates.md`](docs/templates.md) for the full guide.

## Development

```bash
git clone <repository>
cd archforge
./bin/archforge --help    # run directly from source, no install needed
```

See [`docs/development.md`](docs/development.md) and
[`CONTRIBUTING.md`](CONTRIBUTING.md).

## Testing

```bash
make test
# or
bash tests/run_all.sh
```

```bash
make lint    # ShellCheck
make check   # lint + test
```

## Roadmap

```text
[x] CLI inicial
[x] Clean Architecture + DDD
[x] MVC
[x] MMVC
[x] Template discovery
[x] Testes
[x] CI

[ ] Hexagonal Architecture
[ ] Onion Architecture
[ ] CQRS
[ ] Vertical Slice
[ ] Project generators
[ ] Language presets
[ ] Framework presets
[ ] Plugin system
[ ] Interactive mode
[ ] Configuration file
[ ] Remote templates
```

## Known limitations

- No `{{PROJECT_NAME}}` substitution inside generated files yet (template
  READMEs contain a placeholder you replace manually).
- No `--force` flag to overwrite an existing directory.
- No language/framework presets (`--language`, `--framework`) yet — see
  Roadmap.
- Metadata format (`archforge.conf`) is a simple `KEY="value"` file, not
  YAML — see [`docs/templates.md`](docs/templates.md) for why.

## Contributing

Contributions are welcome! Please read
[`CONTRIBUTING.md`](CONTRIBUTING.md) first.

## License

[MIT](LICENSE)
