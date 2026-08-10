# ArchForge — Internal Architecture

This document explains how ArchForge itself is organized (not to be
confused with the architecture *templates* it generates — see
[`templates.md`](templates.md) for that).

## Design goals

- **Simplicity** — pure Bash, minimal dependencies.
- **Portability** — Linux, WSL, macOS, and Git Bash on Windows (Bash 4+).
- **Genericity** — the CLI core has zero knowledge of any specific
  architecture template. Adding `hexagonal/` or `cqrs/` never requires
  touching `commands/` or `core/`.
- **Safety** — no `eval`, quoted variables, validated user input, no
  destructive filesystem operations without explicit checks.

## Directory layout

```text
archforge/
├── bin/
│   └── archforge          # Entrypoint: resolves paths, sources modules, dispatches commands
│
├── commands/               # One file per subcommand
│   ├── init.sh
│   ├── list.sh
│   └── info.sh
│
├── core/                    # Reusable building blocks, sourced by bin/archforge
│   ├── config.sh            # Version, paths, exit codes
│   ├── logger.sh             # info/success/warning/error
│   ├── filesystem.sh         # Safe copy/cleanup helpers
│   ├── validation.sh         # Input validation
│   └── template.sh           # Template discovery + metadata loading
│
├── templates/                # Architecture templates (see templates.md)
│   ├── clean-ddd/
│   ├── mvc/
│   └── mmvc/
│
├── tests/                    # Bash test suite
├── docs/                     # This documentation
├── examples/                 # Example usage transcripts per template
└── .github/workflows/ci.yml  # CI pipeline
```

## Execution flow

1. `bin/archforge` is invoked. It resolves its own real path (following
   symlinks, so a global install via `install.sh` works), and derives
   `ARCHFORGE_ROOT` from it.
2. It sources every file in `core/` — these only define functions and
   variables, they don't execute anything on their own (each uses a
   "loaded" guard to avoid being sourced twice).
3. It sources every file in `commands/` — same rule: defining a
   `cmd_<name>` function.
4. `main()` parses the first argument as the command name and dispatches
   to the matching `cmd_<name>` function, or to `--help`/`--version`.

No command file calls another command file directly; they only call
functions exposed by `core/`.

## The template system

The most important architectural decision in this project: **the core
CLI never hardcodes an architecture name.** Instead:

```text
architecture name
       ↓
templates/<architecture>/           (core/template.sh: list_architectures)
       ↓
validate template exists            (core/validation.sh: validate_architecture_exists)
       ↓
copy template                       (core/filesystem.sh: copy_template_to_project)
       ↓
remove ArchForge metadata           (core/filesystem.sh: remove_archforge_metadata)
       ↓
project generated
```

`commands/init.sh` only ever refers to `${arch}` as a variable — it never
branches on specific architecture names. This is what allows new
templates to be added without any change to `commands/` or `core/`.

## Exit codes

Centralized in `core/config.sh`:

| Code | Meaning                  |
|------|---------------------------|
| 0    | Success                   |
| 1    | General error              |
| 2    | Invalid arguments          |
| 3    | Template not found         |
| 4    | Project already exists     |

## Metadata format

Each template carries an `archforge.conf` file — a plain `KEY="value"`
Bash-variable file, not YAML. This was a deliberate simplicity trade-off:
Bash has no built-in YAML parser, and pulling in a third-party dependency
just to read a handful of key/value pairs would go against the project's
"low number of dependencies" goal. See [`templates.md`](templates.md) for
the exact format and how it's parsed safely (in a subshell, so a
misbehaving `archforge.conf` can't affect the CLI's own environment or
execute arbitrary commands in the parent shell).

## Why Bash (for now)

Bash was chosen for v0.1.0 to keep the barrier to entry and the
dependency footprint as low as possible. The codebase is intentionally
organized (small modules, no hidden global state beyond what's documented
in `core/config.sh`, no monolithic scripts) so that a future port to
Node.js/TypeScript — should the project outgrow Bash — can follow the
same command/core/template separation without a redesign.
