# Folder Structure — Backend

Recommended backend structure for a modular FastAPI application.

```txt
apps/api/
  app/
    main.py
    config.py

    core/
      errors.py
      logging.py
      constants.py
      result.py
      security.py

    db/
      session.py
      base.py
      migrations/
        # Alembic migrations, optional for MVP

    storage/
      local_storage.py
      storage_service.py

    ai/
      providers/
        base.py
        openai_provider.py
        anthropic_provider.py

      prompts/
        analyze_session.md
        generate_concepts.md
        generate_content.md
        fix_invalid_items.md
        generate_preview.md

      schemas/
        ai_summary.py
        ai_concept.py
        ai_generated_content.py
        ai_fix_result.py

      service.py
      prompt_context.py

    modules/
      sessions/
        api/
          router.py
          schemas.py
        domain/
          models.py
          enums.py
        application/
          service.py
          commands.py
          queries.py
        infrastructure/
          repository.py

      files/
        api/
          router.py
          schemas.py
        domain/
          models.py
          enums.py
        application/
          service.py
          parsers.py
          file_reader.py
        infrastructure/
          repository.py
          file_storage.py

      understanding/
        api/
          router.py
          schemas.py
        domain/
          models.py
          enums.py
        application/
          service.py
          prompt_builder.py
        infrastructure/
          repository.py

      concepts/
        api/
          router.py
          schemas.py
        domain/
          models.py
          enums.py
        application/
          service.py
          prompt_builder.py
        infrastructure/
          repository.py

      generation/
        api/
          router.py
          schemas.py
        domain/
          models.py
          enums.py
        application/
          service.py
          prompt_builder.py
        infrastructure/
          repository.py

      validation/
        api/
          router.py
          schemas.py
        domain/
          models.py
          enums.py
        application/
          service.py
          validation_pipeline.py
        checks/
          json_check.py
          schema_check.py
          required_fields_check.py
          enum_check.py
          balance_check.py
          duplicate_check.py
          reference_check.py
        infrastructure/
          repository.py

      preview/
        api/
          router.py
          schemas.py
        application/
          service.py
          preview_renderer.py

      export/
        api/
          router.py
          schemas.py
        domain/
          models.py
          enums.py
        application/
          service.py
          zip_builder.py
          manifest_builder.py
          summary_builder.py
        infrastructure/
          repository.py

      workflows/
        api/
          router.py
          schemas.py
        application/
          generation_workflow.py
          validation_workflow.py

    common/
      pagination.py
      file_types.py
      json_utils.py
      text_utils.py
      ids.py
      datetime_utils.py

  tests/
    modules/
      sessions/
      files/
      understanding/
      concepts/
      generation/
      validation/
      preview/
      export/
      workflows/
    ai/
    storage/

  pyproject.toml
  README.md
```

## Backend module rules

### API layer

```txt
modules/*/api/
```

Contains:

```txt
router.py
schemas.py
```

Responsibilities:

```txt
HTTP endpoints
request DTOs
response DTOs
FastAPI dependencies
```

Should not contain business logic.

### Domain layer

```txt
modules/*/domain/
```

Contains:

```txt
models.py
enums.py
```

Responsibilities:

```txt
domain models
statuses
enums
module-specific constants
```

Should not import API or infrastructure code.

### Application layer

```txt
modules/*/application/
```

Contains:

```txt
service.py
commands.py
queries.py
prompt_builder.py
```

Responsibilities:

```txt
use cases
business rules
module orchestration
calling repositories
calling AI services when needed
```

### Infrastructure layer

```txt
modules/*/infrastructure/
```

Contains:

```txt
repository.py
file_storage.py
```

Responsibilities:

```txt
database access
storage integration
external persistence
```

### Workflows module

Use this module only for cross-module orchestration.

Example:

```txt
Create session
→ upload files
→ analyze files
→ generate concepts
→ generate content
→ validate
→ export
```

Individual modules should stay independent. If many modules need to cooperate, the workflow module coordinates them.

## Dependency direction

Recommended direction:

```txt
api → application → domain
application → infrastructure
infrastructure → domain
```

Avoid:

```txt
sessions.service imports concepts.service
concepts.service imports generation.service
generation.service imports validation.service
```

Use:

```txt
workflows/generation_workflow.py
```

for multi-step processes.

## MVP backend libraries

```txt
fastapi
uvicorn
pydantic
sqlmodel
sqlite
python-multipart
aiofiles
pyyaml
jsonschema
python-dotenv
openai or anthropic
pytest
ruff
```

## Later backend libraries

```txt
sqlalchemy
alembic
postgresql
langgraph
redis
rq
orjson
tenacity
mypy
pre-commit
```
