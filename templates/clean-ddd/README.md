# {{PROJECT_NAME}}

Generated with [ArchForge](https://github.com/archforge/archforge) using the
**Clean Architecture + DDD** template.

> Replace `{{PROJECT_NAME}}` above with your actual project name — ArchForge
> does not currently perform template substitution (see project roadmap).

## Architecture

This project follows a domain-centric architecture combining **Clean
Architecture** with **Domain-Driven Design (DDD)** principles. Dependencies
always point inward, toward the domain.

```
src/
├── domain/           # Enterprise business rules
├── application/       # Application business rules
├── infrastructure/    # Frameworks, drivers, external tools
└── presentation/      # UI, controllers, HTTP layer
```

## Layers

### `domain/`

The core of the system. Contains no dependencies on any other layer.

- `entities/` — Core business objects with identity and lifecycle.
- `value-objects/` — Immutable objects defined solely by their attributes.
- `repositories/` — Interfaces (ports) describing persistence contracts.
  Implementations live in `infrastructure/repositories/`.
- `services/` — Domain services that encapsulate logic that doesn't
  naturally belong to a single entity or value object.

### `application/`

Orchestrates the domain to fulfill specific use cases. Depends on `domain/`
only.

- `dtos/` — Data Transfer Objects used at the boundaries of use cases.
- `use-cases/` — Application-specific business rules (a.k.a. interactors).
- `services/` — Application services that coordinate multiple use cases or
  external concerns via interfaces defined in `domain/`.

### `infrastructure/`

Implements the interfaces defined by `domain/` and `application/`. Depends
on both.

- `database/` — Database configuration, connections, migrations.
- `repositories/` — Concrete implementations of `domain/repositories/`.
- `providers/` — Adapters for external services (email, storage, etc.).

### `presentation/`

The entry point for the outside world (HTTP, CLI, queues, etc.). Depends on
`application/` to execute use cases.

- `controllers/` — Translate incoming requests into use case calls.
- `middlewares/` — Cross-cutting concerns (auth, logging, error handling).
- `routes/` — Route definitions that map endpoints to controllers.

## Principles

- **Dependency Inversion** — inner layers define interfaces; outer layers
  implement them.
- **Separation of Concerns** — each layer has a single, well-defined
  responsibility.
- **Domain Isolation** — the domain layer has zero framework or
  infrastructure dependencies.

## Notes

This template is intentionally framework- and language-agnostic. It does
not assume Node.js, TypeScript, NestJS, Spring, or any other specific
technology stack — adapt the folder contents to the stack of your choice.
