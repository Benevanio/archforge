# Example: Generating an MMVC project

```bash
$ archforge info mmvc
Architecture: MMVC

Description:
Model-View-ViewModel-Controller: an MVC variant that introduces an explicit view-model layer to shape data for presentation without polluting controllers or views.

Layers:

  models
  views
  view-models
  controllers
  services
  routes

Principles:

  Separation of Concerns
  Presentation Logic Isolation
  Single Responsibility

Template version: 1.0.0
```

```bash
$ archforge init dashboard-app --arch mmvc
[INFO] Creating project 'dashboard-app' with architecture 'mmvc'...
[SUCCESS] Project 'dashboard-app' created successfully.
```

Resulting structure:

```text
dashboard-app/
├── .gitignore
├── README.md
├── src/
│   ├── models/
│   ├── views/
│   ├── view-models/
│   ├── controllers/
│   ├── services/
│   └── routes/
└── tests/
```

From here, you'd typically:

1. Define your data models in `src/models/`.
2. Build view-models in `src/view-models/` that shape model data for a
   specific screen (formatting, aggregation, display-only flags).
3. Keep `src/views/` consuming only view-models, never raw models.
4. Implement controllers in `src/controllers/` that orchestrate
   `services/`, `models/`, and build the right view-model for each view.

> **Note:** ArchForge's `mmvc` template uses a specific interpretation of
> "MMVC" (MVC + an explicit View-Model layer). See
> [`templates/mmvc/README.md`](../templates/mmvc/README.md) for the full
> rationale — the term isn't universally standardized across the
> industry.
