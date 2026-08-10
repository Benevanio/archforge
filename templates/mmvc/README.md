# {{PROJECT_NAME}}

Generated with [ArchForge](https://github.com/archforge/archforge) using the
**MMVC** template.

> Replace `{{PROJECT_NAME}}` above with your actual project name — ArchForge
> does not currently perform template substitution (see project roadmap).

## Architecture

```
src/
├── models/         # Data and business logic
├── views/          # Presentation / templates
├── view-models/    # Presentation-shaped data, decoupled from views/models
├── controllers/    # Request handling and orchestration
├── services/       # Reusable business logic
└── routes/         # Endpoint-to-controller mapping
```

## What "MMVC" means in ArchForge

There is no single, universally agreed-upon academic definition of
"MMVC". Several communities use the term differently (some use it as a
synonym for MVVM, others for a layered MVC variant). **ArchForge adopts
the following interpretation**, and documents it explicitly so there is no
ambiguity:

> MMVC is MVC with an explicit **View-Model** layer inserted between
> `controllers/` and `views/`. The view-model's job is to shape and
> format data specifically for presentation, so that views stay free of
> logic and controllers stay free of formatting concerns.

## Layer responsibilities

### `models/`

Data and business rules, same role as in classic MVC.

### `view-models/`

Transforms domain/model data into a shape tailored for a specific view —
formatting dates, computing display-only flags, aggregating fields, etc.
View-models depend on `models/` but never the other way around.

### `views/`

Pure presentation. Views consume `view-models/` output, not `models/`
directly.

### `controllers/`

Receive input, invoke `services/` and `models/`, build the appropriate
`view-models/`, and select a `view` to render.

### `services/`

Business logic shared across controllers.

### `routes/`

Declarative endpoint-to-controller mapping.

## How MMVC differs from MVC

In classic MVC, controllers often pass model data directly to views,
leaving views (or controllers) responsible for formatting it. MMVC makes
that formatting step an explicit, testable layer (`view-models/`), which
keeps views simpler and controllers focused on orchestration rather than
presentation details.

## Notes

This template is framework-agnostic. Adapt it to your language and
framework of choice.
