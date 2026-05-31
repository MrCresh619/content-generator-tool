# Universal Game Content Generator — MVP Description

## 1. MVP Goal

The goal of the MVP is to create a local web tool for generating structured game content based on files provided by the user.

The application should run locally via Docker Compose. The only external cost should be the AI API.

The most important product principle:

```txt
JSON is the source of truth.
Natural language description is only a preview generated from JSON.
```

The MVP should not be a full agent system. It should be a simple, controlled pipeline:

```txt
Upload files
→ AI understanding summary
→ User corrections
→ Generate concepts
→ User approval
→ Generate structured JSON
→ Validate
→ Preview
→ Export
```

---

## 2. Repository Decision

Recommended layout for the MVP:

```txt
Single repository.
No Turborepo.
No separate repositories for FE and BE.
```

Rationale:

- this is one product, not two independent systems,
- FE and BE will be developed together,
- easier to maintain documentation, diagrams, Docker Compose, and API contracts in one place,
- easier to start the project with a single command,
- less organizational overhead,
- better for an internal tool.

Proposed repo structure:

```txt
game-content-generator/
  apps/
    web/
    api/
  docs/
    diagrams/
    product/
    architecture/
  docker/
  data/
    uploads/
    exports/
  docker-compose.yml
  Makefile
  README.md
```

Separate repositories make sense only when:

- frontend and backend have separate teams,
- the backend is to be used by several different products,
- the system will be publicly hosted and released independently,
- you need separate CI/CD pipelines,
- you want to version the API separately as a product.

For the MVP: a single repo is best.

---

## 3. MVP Tech Stack

### Frontend

```txt
React
Vite
TypeScript
TanStack Query
React Router
React Hook Form
Zod
Tailwind CSS
shadcn/ui optional
Monaco Editor optional
```

### Backend

```txt
Python
FastAPI
Uvicorn
Pydantic
SQLModel or SQLAlchemy
SQLite
python-multipart
aiofiles
PyYAML
jsonschema
python-dotenv
```

### AI

```txt
OpenAI SDK or Anthropic SDK
Simple AI pipeline without LangGraph
Pydantic models for structured output
```

### Validation

```txt
Pydantic
jsonschema
custom validation checks
```

### Export

```txt
Python standard library: json, pathlib, zipfile
```

### Dev tools

```txt
Docker
Docker Compose
Makefile
ruff
pytest
mypy optional
```

---

## 4. FE Libraries — Details

### react

Main UI library.

Use cases:

- application screens,
- session flow,
- concept review,
- JSON preview,
- final review.

### vite

Build tool and dev server for the frontend.

Use cases:

- fast local development,
- simple build,
- no need for SSR.

### typescript

Frontend typing.

Use cases:

- DTO types,
- screen models,
- API response types,
- more stable refactoring.

### @tanstack/react-query

Server state management.

Use cases:

- fetching sessions,
- upload status,
- concept list,
- validation results,
- retry/fetching/cache.

### react-router-dom

Routing across application screens.

Example routes:

```txt
/
/sessions/new
/sessions/:sessionId/understanding
/sessions/:sessionId/concepts
/sessions/:sessionId/generated
/sessions/:sessionId/export
```

### react-hook-form

Forms.

Use cases:

- session settings,
- file roles,
- additional notes,
- generation setup.

### zod

Frontend data validation.

Use cases:

- form validation,
- input types,
- simple DTO compatibility.

### tailwindcss

UI styling.

Use cases:

- fast layout,
- consistent spacing,
- responsive views,
- cards, lists, statuses.

### shadcn/ui

Optional for ready-made UI components.

Use cases:

- buttons,
- dialogs,
- selects,
- table,
- tabs,
- cards,
- toast.

### monaco-editor

Optional for JSON editing.

Use cases:

- manual editing of generated JSON,
- final JSON preview,
- validation debugging.

Initially, a plain `textarea` can be used instead of Monaco.

---

## 5. BE Libraries — Details

### fastapi

Main API framework.

Use cases:

- session endpoints,
- file upload,
- concept generation,
- content generation,
- validation,
- export.

### uvicorn

ASGI server for FastAPI.

Use cases:

- running the backend locally,
- running the API in Docker.

### pydantic

Data models and validation for internal application structures.

Use cases:

- request/response DTOs,
- AI output models,
- validation report models,
- generated content models.

### sqlmodel or sqlalchemy

Database layer.

MVP recommendation:

```txt
SQLModel, if you want a simpler start.
SQLAlchemy, if you want more control and a more classic approach.
```

For this project at MVP, I would choose `SQLModel`.

### sqlite

Local database.

Use cases:

- sessions,
- uploaded file metadata,
- AI summaries,
- draft concepts,
- generated items,
- validation reports,
- export packages.

### python-multipart

File upload handling in FastAPI.

### aiofiles

Asynchronous file operations.

Use cases:

- saving uploads,
- reading session files,
- saving exports.

### pyyaml

YAML file parsing.

Use cases:

- balance-rules.yaml,
- generation-request.yaml,
- project-context.yaml.

### jsonschema

Validation of dynamic JSON schemas provided by the user.

This is important because Pydantic validates your application models, but the user may provide their own schema for events, skills, items, etc.

### python-dotenv

Local configuration via `.env`.

Use cases:

```txt
AI_API_KEY
DATABASE_URL
UPLOAD_DIR
EXPORT_DIR
MAX_UPLOAD_SIZE_MB
```

---

## 6. MVP Modules

### sessions

Responsible for:

- creating sessions,
- session status,
- basic metadata,
- moving between steps.

### files

Responsible for:

- file upload,
- saving files,
- role assignment,
- reading content.

### ai

Responsible for:

- session analysis,
- generating summary,
- generating draft concepts,
- generating structured JSON,
- simple repair of invalid items.

### validation

Responsible for:

- JSON parse validation,
- schema validation,
- required fields,
- enum values,
- balance rules,
- duplicate detection,
- reference checks.

### export

Responsible for:

- generating `content.json`,
- generating `manifest.json`,
- generating `validation-report.json`,
- creating a ZIP archive.

---

## 7. MVP Flow

### 1. Create session

The user creates a new generation session.

Data:

```txt
sessionId
name
createdAt
status = draft
```

### 2. Upload files

The user uploads input files.

Allowed formats in the MVP:

```txt
.json
.yaml
.yml
.md
.txt
.csv optional
```

### 3. Assign file roles

The user assigns roles:

```txt
Project Context
Balance Rules
Existing Content
Output Schema
Examples
Additional Notes
Other
```

### 4. AI understanding summary

The backend builds context from files and sends it to the AI.

The AI returns:

```txt
detectedContentType
detectedOutputFormat
detectedFields
detectedRules
detectedTone
warnings
```

### 5. User corrections

The user can add notes and re-run the analysis.

### 6. Generate draft concepts

The user specifies the number of items.

The AI generates:

```txt
title
shortConcept
tags
```

### 7. Concept review

The user can:

```txt
accept
reject
edit
regenerate
```

### 8. Generate full structured JSON

The AI generates full JSON only for accepted concepts.

### 9. Validate

The system validates the output.

### 10. Preview

The UI shows a human-readable preview generated from JSON.

### 11. Export

The user downloads:

```txt
content.json
```

or:

```txt
generated-content.zip
```

---

## 8. Proposed MVP Endpoints

```txt
POST   /api/sessions
GET    /api/sessions/{session_id}
PATCH  /api/sessions/{session_id}

POST   /api/sessions/{session_id}/files
GET    /api/sessions/{session_id}/files
PATCH  /api/sessions/{session_id}/files/{file_id}/role

POST   /api/sessions/{session_id}/analyze
GET    /api/sessions/{session_id}/understanding
PATCH  /api/sessions/{session_id}/understanding

POST   /api/sessions/{session_id}/concepts/generate
GET    /api/sessions/{session_id}/concepts
PATCH  /api/sessions/{session_id}/concepts/{concept_id}

POST   /api/sessions/{session_id}/content/generate
GET    /api/sessions/{session_id}/content

POST   /api/sessions/{session_id}/validate
GET    /api/sessions/{session_id}/validation-report

POST   /api/sessions/{session_id}/export
GET    /api/sessions/{session_id}/export/{export_id}/download
```

---

## 9. Minimal MVP Data Model

### GenerationSession

```txt
id
name
status
created_at
updated_at
```

### UploadedFile

```txt
id
session_id
name
role
mime_type
size
storage_path
created_at
```

### AIUnderstandingSummary

```txt
id
session_id
detected_content_type
detected_schema
detected_rules
detected_style
warnings
created_at
```

### DraftConcept

```txt
id
session_id
title
short_concept
tags
status
created_at
```

### GeneratedContentItem

```txt
id
session_id
concept_id
content_type
json_data
status
created_at
```

### ValidationReport

```txt
id
session_id
status
issues
created_at
```

### ExportPackage

```txt
id
session_id
format
storage_path
created_at
```

---

## 10. Backend Folder

```txt
apps/api/
  app/
    main.py
    config.py

    modules/
      sessions/
        router.py
        service.py
        models.py
        schemas.py

      files/
        router.py
        service.py
        models.py
        schemas.py

      ai/
        router.py
        service.py
        prompts/
          analyze_session.md
          generate_concepts.md
          generate_content.md
          fix_invalid_items.md

      validation/
        service.py
        checks/
          json_check.py
          schema_check.py
          balance_check.py
          duplicate_check.py
          reference_check.py

      export/
        router.py
        service.py

    db/
      session.py
      models.py

    storage/
      local_storage.py
```

---

## 11. Frontend Folder

```txt
apps/web/
  src/
    app/
      router.tsx
      providers.tsx

    features/
      sessions/
      files/
      understanding/
      concepts/
      generated-content/
      validation/
      export/

    shared/
      api/
      components/
      types/
      utils/
```

---

## 12. Docker Compose MVP

Services:

```txt
web
api
```

Volumes:

```txt
app_data
```

Local files:

```txt
/data/app.db
/data/uploads
/data/exports
```

Do not add Postgres, MinIO, Redis, or a worker for the MVP.

---

## 13. What Does NOT Go Into the MVP

Do not add at the start:

```txt
LangGraph
Postgres
Redis
Celery/RQ
Auth
Multi-user accounts
Cloud deployment
MinIO
External object storage
Billing
Team workspaces
Unity importer
Plugin marketplace
```

These are for later.

---

## 14. MVP Success Criteria

The MVP is ready when you can complete the entire flow:

```txt
Create session
→ Upload files
→ AI summary
→ Add corrections
→ Generate concepts
→ Approve concepts
→ Generate JSON
→ Validate
→ Preview
→ Download JSON/ZIP
```

And when the generated content is:

```txt
valid JSON
schema-compliant
free of obvious duplicates
usable in a game project
```
