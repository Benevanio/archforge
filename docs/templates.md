# Creating and Understanding ArchForge Templates

## What is a template?

A template is a directory under `templates/` that represents a complete,
ready-to-copy project skeleton for a given architecture pattern. ArchForge
discovers templates dynamically — there is no list of architecture names
anywhere in the CLI's source code.

## Anatomy of a template

At minimum, a template needs:

```text
templates/<name>/
└── archforge.conf
```

A realistic template looks like:

```text
templates/<name>/
├── archforge.conf      # required — metadata, see below
├── README.md            # recommended — explains the architecture
├── .gitignore            # optional
├── src/                   # your folder structure
│   └── ...
└── tests/
    └── ...
```

Everything inside the template directory (except `archforge.conf`, which
is stripped automatically) is copied verbatim into the generated project.

## The metadata file: `archforge.conf`

Pure Bash cannot parse YAML without extra dependencies, so ArchForge uses
a minimal, portable `KEY="value"` format instead — a deliberate
simplicity trade-off documented in [`architecture.md`](architecture.md).

```bash
NAME="Clean Architecture + DDD"
DESCRIPTION="Domain-centric architecture based on Clean Architecture and Domain-Driven Design principles."
VERSION="1.0.0"
LAYERS="domain application infrastructure presentation"
PRINCIPLES="Dependency Inversion,Separation of Concerns,Domain Isolation"
```

Recognized fields:

| Field         | Required | Format                                   | Used by             |
|---------------|----------|-------------------------------------------|----------------------|
| `NAME`        | Yes      | Single-line string                        | `archforge info`     |
| `DESCRIPTION` | Yes      | Single-line string (keep it on one line — see note below) | `archforge info` |
| `VERSION`     | No       | Semver-like string                        | `archforge info`     |
| `LAYERS`      | No       | Space-separated list                      | `archforge info`     |
| `PRINCIPLES`  | No       | Comma-separated list                      | `archforge info`     |

> **Note on `DESCRIPTION`:** keep it on a single line. ArchForge's parser
> reads `archforge.conf` line by line looking for `KEY=value` pairs; a
> description split across multiple lines will have its later lines
> silently ignored. If you need a longer explanation, put it in the
> template's `README.md` instead.

`archforge.conf` is sourced in an isolated subshell (never in the CLI's
own process) purely to read these fields — it cannot execute arbitrary
code that affects ArchForge itself, and it is always removed from the
final generated project.

## Adding a new architecture (e.g. Hexagonal)

No core code changes required. Just:

```text
templates/
└── hexagonal/
    ├── archforge.conf
    ├── README.md
    ├── src/
    └── tests/
```

With `archforge.conf`:

```bash
NAME="Hexagonal Architecture"
DESCRIPTION="Ports and adapters architecture isolating core logic from external systems."
VERSION="1.0.0"
LAYERS="domain ports adapters"
PRINCIPLES="Dependency Inversion,Testability,Technology Independence"
```

That's it. From this point on:

```bash
archforge list
```

```text
Available architectures:

  clean-ddd
  hexagonal
  mmvc
  mvc
```

```bash
archforge info hexagonal
archforge init my-service --arch hexagonal
```

all work automatically — `core/template.sh`'s `list_architectures`
function simply scans `templates/*/` for directories containing an
`archforge.conf` file.

## Built-in templates

| Template     | Command                              | Docs                                      |
|---------------|----------------------------------------|--------------------------------------------|
| `clean-ddd`  | `archforge init <name> --arch clean-ddd` | [`templates/clean-ddd/README.md`](../templates/clean-ddd/README.md) |
| `mvc`        | `archforge init <name> --arch mvc`        | [`templates/mvc/README.md`](../templates/mvc/README.md)             |
| `mmvc`       | `archforge init <name> --arch mmvc`       | [`templates/mmvc/README.md`](../templates/mmvc/README.md)           |

See also the [`examples/`](../examples) directory for full usage
transcripts of each template.

## Guidelines for new templates

- Stay framework- and language-agnostic unless you're intentionally
  publishing a framework-specific variant (e.g. `clean-ddd-nestjs` as a
  separate template).
- Document each layer's responsibility in the template's own `README.md`.
- If your architecture's name is ambiguous or has multiple competing
  definitions in the industry (as `mmvc` does), state clearly which
  interpretation your template follows — don't assume readers share your
  definition.
- Keep empty directories tracked with a `.gitkeep` file so the folder
  structure survives being committed to Git.
