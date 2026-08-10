# {{PROJECT_NAME}}

Generated with [ArchForge](https://github.com/archforge/archforge) using the
**MVC** template.

> Replace `{{PROJECT_NAME}}` above with your actual project name — ArchForge
> does not currently perform template substitution (see project roadmap).

## Architecture

```
src/
├── models/         # Data and business logic
├── views/          # Presentation / templates
├── controllers/    # Request handling and orchestration
├── routes/         # Endpoint-to-controller mapping
├── services/        # Reusable business logic shared across controllers
└── middlewares/     # Cross-cutting request/response concerns
```

## Layer responsibilities

### `models/`

Represents the application's data and the business rules directly tied to
that data. Models should not know about HTTP, routing, or views.

### `views/`

Responsible for presentation only — rendering data provided by controllers
into a format consumable by the client (HTML, JSON templates, etc.). Views
should not contain business logic.

### `controllers/`

Receive input (typically from `routes/`), invoke `models/` and `services/`
as needed, and select the appropriate `views/` (or response payload) to
return. Controllers coordinate; they don't implement business rules
themselves.

### `routes/`

Declares the mapping between endpoints (or commands) and the controller
methods that handle them. Keep routing declarative — no business logic
here.

### `services/`

Business logic that is reused across multiple controllers, or that is
complex enough to not belong directly in a controller or model.

### `middlewares/`

Cross-cutting concerns applied to requests/responses: authentication,
logging, error handling, input validation, etc.

## Notes

This template is intentionally framework-agnostic. Adapt the folder
contents to the language and framework of your choice (Express, Rails,
Laravel, Django, etc.).
