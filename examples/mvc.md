# Example: Generating an MVC project

```bash
$ archforge info mvc
Architecture: MVC

Description:
Classic Model-View-Controller architecture, separating data, presentation, and control flow into three interconnected layers.

Layers:

  models
  views
  controllers
  routes
  services
  middlewares

Principles:

  Separation of Concerns
  Single Responsibility
  Convention over Configuration

Template version: 1.0.0
```

```bash
$ archforge init blog-app --arch mvc
[INFO] Creating project 'blog-app' with architecture 'mvc'...
[SUCCESS] Project 'blog-app' created successfully.
```

Resulting structure:

```text
blog-app/
├── .gitignore
├── README.md
├── src/
│   ├── controllers/
│   ├── models/
│   ├── views/
│   ├── routes/
│   ├── services/
│   └── middlewares/
└── tests/
```

From here, you'd typically:

1. Define your data models in `src/models/`.
2. Add view templates in `src/views/`.
3. Implement controllers in `src/controllers/` that use `models/` and
   `services/`, and select a view to render.
4. Wire endpoints to controllers in `src/routes/`.
5. Add cross-cutting concerns (auth, logging) in `src/middlewares/`.

See [`templates/mvc/README.md`](../templates/mvc/README.md) for a full
explanation of each layer's responsibility.
