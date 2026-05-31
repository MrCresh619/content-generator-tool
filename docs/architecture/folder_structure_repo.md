# Folder Structure — Repository

Recommended structure for the whole project.

```txt
game-content-generator/
  apps/
    api/
      # FastAPI backend application
    web/
      # React + Vite frontend application

  docs/
    README.md
    diagrams/
      product-flow.md
      screen-flow.md
      system-architecture.md
      data-flow.md
      domain-model.md
      validation-pipeline.md
      session-state.md
      sequence-generate-concepts.md
      sequence-generate-full-content.md
      deployment.md

    product/
      mvp-description.md
      complete-project-description.md
      user-flow.md
      export-format.md

    architecture/
      decisions/
        adr-001-single-repository.md
        adr-002-json-as-source-of-truth.md
        adr-003-local-first-docker-setup.md
      backend.md
      frontend.md
      validation.md
      ai-workflow.md

    api/
      openapi.md
      endpoints.md

  data/
    uploads/
      # Local uploaded files, mounted as Docker volume
    exports/
      # Generated JSON / ZIP export packages
    app.db
      # Local SQLite database for MVP

  docker/
    api.Dockerfile
    web.Dockerfile

  scripts/
    dev.sh
    reset-data.sh
    generate-openapi.sh
    generate-client-types.sh

  .env.example
  .gitignore
  docker-compose.yml
  Makefile
  README.md
```

## Main rules

### One repository

Use one repository for the whole project.

Reason:

```txt
frontend + backend + docs + docker = one product
```

Do not split into separate FE and BE repositories at this stage.

### No Turborepo

This project does not need Turborepo.

Use:

```txt
Makefile
Docker Compose
separate package managers inside apps/web and apps/api
```

### Contracts

Backend owns the API contract.

Recommended flow:

```txt
FastAPI OpenAPI
→ generated frontend API types
→ apps/web/src/shared/api/generated/
```

### Local-first setup

The MVP should run locally with:

```txt
docker compose up
```

or:

```txt
make dev
```

The only external cost should be the AI API provider.
