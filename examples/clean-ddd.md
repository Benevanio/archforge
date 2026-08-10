# Example: Generating a Clean Architecture + DDD project

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

Template version: 1.0.0
```

```bash
$ archforge init payment-service --arch clean-ddd
[INFO] Creating project 'payment-service' with architecture 'clean-ddd'...
[SUCCESS] Project 'payment-service' created successfully.
```

Resulting structure:

```text
payment-service/
├── .gitignore
├── README.md
├── src/
│   ├── domain/
│   │   ├── entities/
│   │   ├── value-objects/
│   │   ├── repositories/
│   │   └── services/
│   ├── application/
│   │   ├── dtos/
│   │   ├── use-cases/
│   │   └── services/
│   ├── infrastructure/
│   │   ├── database/
│   │   ├── repositories/
│   │   └── providers/
│   └── presentation/
│       ├── controllers/
│       ├── middlewares/
│       └── routes/
└── tests/
    ├── unit/
    └── integration/
```

From here, you'd typically:

1. Define your domain entities in `src/domain/entities/`.
2. Define repository interfaces in `src/domain/repositories/`.
3. Implement use cases in `src/application/use-cases/`, depending only on
   `domain/`.
4. Implement the repository interfaces in
   `src/infrastructure/repositories/`.
5. Wire everything up in `src/presentation/controllers/` and
   `src/presentation/routes/`.

See [`templates/clean-ddd/README.md`](../templates/clean-ddd/README.md)
for a full explanation of each layer's responsibility.
