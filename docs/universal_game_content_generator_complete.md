# Universal Game Content Generator — Complete Project Description

## 1. Goal of the complete product

Universal Game Content Generator is a locally hosted or privately hosted web application for generating structural game content based on files supplied by the user.

The application is not rigidly tied to a single content type. It can generate:

```txt
events
skills
items
quests
dialogues
enemies
achievements
cards
locations
NPCs
loot tables
```

The foundation of operation is a generation session.

The user supplies files, AI analyzes context, the user accepts the direction, AI generates concepts, the user selects good proposals, AI generates full JSON, the system validates output and allows downloading a ready package.

The most important rule:

```txt
JSON is the source of truth.
Human-readable preview is only a view generated from JSON.
```

---

## 2. Architectural decision: single repository

Recommended model:

```txt
Single simple monorepo repository.
Without Turborepo.
```

Structure:

```txt
game-content-generator/
  apps/
    web/
    api/
  docs/
    diagrams/
    product/
    architecture/
    api/
  data/
    uploads/
    exports/
  docker/
  scripts/
  docker-compose.yml
  Makefile
  README.md
```

Why a single repo:

- FE and BE are part of one product,
- easier local development,
- one Docker Compose,
- one documentation set,
- one set of diagrams,
- one change history,
- simpler API contract synchronization,
- less overhead than with two repositories.

When to split into two repositories:

- the backend becomes a public API used by multiple applications,
- FE and BE have separate release cycles,
- there are separate teams,
- the backend has its own documentation, SDK, and lifecycle,
- serious public deployment and CI/CD are added.

For this project: a single repository is more reasonable.

---

## 3. Target technology stack

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
shadcn/ui
Monaco Editor
Lucide React
date-fns
```

### Backend

```txt
Python
FastAPI
Uvicorn
Pydantic
SQLModel or SQLAlchemy
Alembic
SQLite for MVP
PostgreSQL for extended version
python-multipart
aiofiles
PyYAML
jsonschema
orjson
python-dotenv
tenacity
```

### AI / orchestration

```txt
OpenAI SDK or Anthropic SDK
LangGraph in extended version
LangChain Core optional
Pydantic models for structured outputs
tiktoken optional for token estimation
```

### Validation

```txt
Pydantic
jsonschema
custom validation engine
custom balance rules engine
duplicate detection
reference checks
```

### Storage

MVP:

```txt
SQLite
local filesystem
Docker volume
```

Extended local version:

```txt
PostgreSQL
local filesystem or MinIO
Docker volumes
```

### Background jobs

MVP:

```txt
No separate worker.
Synchronous operations or simple FastAPI async tasks.
```

Extended version:

```txt
RQ + Redis
or Celery + Redis
or Dramatiq + Redis
```

Recommendation:

```txt
RQ + Redis
```

Reason: simpler than Celery and sufficient for an internal tool.

### DevOps

```txt
Docker
Docker Compose
Makefile
ruff
pytest
mypy
pre-commit optional
```

---

## 4. Frontend libraries — description

### react

Main library for building the UI.

Responsible for:

- session screens,
- upload files,
- AI understanding summary,
- concept selection,
- generated content review,
- validation results,
- export screen.

### vite

Dev server and build tool for the React application.

Good fit because the application does not need SSR.

### typescript

Typing of the UI layer and API DTOs.

Example types:

```txt
GenerationSession
UploadedFile
AIUnderstandingSummary
DraftConcept
GeneratedContentItem
ValidationReport
ExportPackage
```

### @tanstack/react-query

Server state management.

Responsible for:

- session cache,
- fetching concepts,
- upload status,
- validation results,
- request retry,
- data invalidation after mutations.

### react-router-dom

Application routing.

Example routes:

```txt
/
/sessions
/sessions/new
/sessions/:sessionId/setup
/sessions/:sessionId/understanding
/sessions/:sessionId/concepts
/sessions/:sessionId/content
/sessions/:sessionId/validation
/sessions/:sessionId/export
```

### react-hook-form

Form handling.

Forms:

- session setup,
- file roles,
- generation setup,
- correction notes,
- concept edit,
- manual JSON correction.

### zod

Form validation on the frontend.

Responsible for:

- required fields,
- number of elements,
- max limits,
- file role validation,
- local DTO validation.

### tailwindcss

Styling.

Good for quickly building an internal tool.

### shadcn/ui

UI components.

Usage:

- cards,
- buttons,
- modals,
- tabs,
- tables,
- forms,
- alerts,
- dropdowns,
- toasts.

### monaco-editor

JSON editor.

Usage:

- generated JSON preview,
- manual item editing,
- validation issue path navigation,
- final output inspection.

### lucide-react

Icons.

Usage:

- statuses,
- actions,
- file roles,
- warnings,
- validation issues.

### date-fns

Date formatting.

Usage:

- session history,
- export date,
- validation date.

---

## 5. Backend libraries — description

### fastapi

Backend framework.

Responsible for:

- REST API,
- file upload,
- generation endpoints,
- validation endpoints,
- export/download,
- automatic API documentation.

### uvicorn

ASGI server.

Responsible for running FastAPI.

### pydantic

Internal model validation.

Usage:

- request schemas,
- response schemas,
- AI output models,
- validation report models,
- structured content wrappers.

### sqlmodel / sqlalchemy

ORM.

Recommendation:

- MVP: `SQLModel`
- larger version: `SQLAlchemy + Alembic`

### alembic

Database migrations.

Can be skipped in MVP and added when moving to Postgres.

### sqlite

Local database for MVP.

Stores:

- sessions,
- file metadata,
- summaries,
- concepts,
- generated items,
- validation reports,
- exports.

### postgresql

Database for the complete version.

Better handles:

- many sessions,
- larger data,
- concurrent usage,
- history filtering,
- JSON indexing.

### python-multipart

File upload handling through FastAPI.

### aiofiles

Asynchronous file read and write.

### pyyaml

YAML parsing.

Supports:

```txt
project-context.yaml
balance-rules.yaml
generation-request.yaml
```

### jsonschema

Dynamic JSON schema validation.

Critical because the user may supply a custom schema file.

### orjson

Faster JSON serialization and deserialization.

Not required in MVP, but useful for larger content packages.

### python-dotenv

Local `.env`.

### tenacity

Retry logic.

Usage:

- retry requests to AI API,
- retry on transient failures,
- controlled exponential backoff.

### openai / anthropic

SDK for the selected AI provider.

Best to create an abstraction:

```txt
AIProvider
  generate_summary()
  generate_concepts()
  generate_content()
  fix_invalid_items()
```

So the provider can be swapped easily later.

### langgraph

Workflow engine for the extended version.

Useful when you want:

- explicit workflow nodes,
- session state,
- human-in-the-loop,
- retry/fix loops,
- process resumption,
- better observability of AI steps.

Do not use as the first MVP element.

---

## 6. Main system modules

### 6.1 Sessions Module

Responsible for:

- session creation,
- session status,
- session history,
- moving between stages,
- basic generation configuration.

Entities:

```txt
GenerationSession
SessionStatus
GenerationRequest
```

### 6.2 Files Module

Responsible for:

- upload,
- file roles,
- content parsing,
- file storage,
- file hashes,
- change detection.

Entities:

```txt
UploadedFile
FileRole
ParsedFileContent
```

### 6.3 AI Understanding Module

Responsible for:

- file analysis,
- content type detection,
- schema detection,
- style detection,
- balance rules detection,
- generating summary for the user.

Entities:

```txt
AIUnderstandingSummary
AIUnderstandingWarning
```

### 6.4 Concept Generation Module

Responsible for generating the first iteration.

Output:

```txt
title
shortConcept
tags
suggestedType
riskLevel optional
```

User can:

```txt
accept
reject
edit
regenerate
```

Entities:

```txt
DraftConcept
ConceptStatus
```

### 6.5 Content Generation Module

Responsible for generating full JSON for accepted concepts.

Output:

```txt
GeneratedContentItem
jsonData
contentType
sourceConceptId
status
```

### 6.6 Validation Module

Responsible for checking output.

Checks:

```txt
JSON validity
Schema validation
Required fields validation
Enum validation
Balance validation
Duplicate detection
Reference checks
Custom rules
```

Entities:

```txt
ValidationReport
ValidationIssue
ValidationSeverity
```

### 6.7 Preview Module

Generates human-readable preview from JSON.

Important:

```txt
Preview is not the source of truth.
Preview is a render of JSON.
```

### 6.8 Export Module

Generates:

```txt
content.json
manifest.json
validation-report.json
generation-summary.md
generated-content.zip
```

Entities:

```txt
ExportPackage
ExportFormat
```

### 6.9 AI Workflow Module

In MVP this is a plain pipeline.

In the full version it may be LangGraph.

Nodes:

```txt
analyze_files
wait_for_summary_approval
generate_concepts
wait_for_concept_selection
generate_content
validate_content
fix_invalid_items
generate_preview
export_package
```

---

## 7. Full product flow

### 1. Create Session

User creates a new session.

### 2. Upload Files

User uploads files.

Roles:

```txt
Project Context
Balance Rules
Existing Content
Output Schema
Examples
Additional Notes
Other
```

### 3. AI Understanding

AI analyzes files and returns summary.

Summary contains:

```txt
detectedContentType
detectedJsonStructure
detectedBalanceRules
detectedTone
detectedConstraints
warnings
```

### 4. User Correction

User confirms or corrects summary.

### 5. Generation Setup

User provides:

```txt
amount
optional theme
optional stage
optional extra prompt
```

### 6. Draft Concepts

AI generates:

```txt
title
shortConcept
tags
```

### 7. Concept Review

User selects good concepts.

### 8. Full JSON Generation

AI generates structured JSON.

### 9. Validation

System checks output.

### 10. Fix Loop

Invalid items can be:

```txt
auto-fixed by AI
edited manually
regenerated
rejected
```

### 11. Human Preview

System renders preview from JSON.

### 12. Final Review

User accepts or returns to editing.

### 13. Export

User downloads JSON or ZIP.

---

## 8. Target API endpoints

### Sessions

```txt
POST   /api/sessions
GET    /api/sessions
GET    /api/sessions/{session_id}
PATCH  /api/sessions/{session_id}
DELETE /api/sessions/{session_id}
```

### Files

```txt
POST   /api/sessions/{session_id}/files
GET    /api/sessions/{session_id}/files
GET    /api/sessions/{session_id}/files/{file_id}
PATCH  /api/sessions/{session_id}/files/{file_id}/role
DELETE /api/sessions/{session_id}/files/{file_id}
```

### AI Understanding

```txt
POST   /api/sessions/{session_id}/analyze
GET    /api/sessions/{session_id}/understanding
PATCH  /api/sessions/{session_id}/understanding
POST   /api/sessions/{session_id}/understanding/approve
```

### Concepts

```txt
POST   /api/sessions/{session_id}/concepts/generate
GET    /api/sessions/{session_id}/concepts
PATCH  /api/sessions/{session_id}/concepts/{concept_id}
POST   /api/sessions/{session_id}/concepts/{concept_id}/accept
POST   /api/sessions/{session_id}/concepts/{concept_id}/reject
POST   /api/sessions/{session_id}/concepts/regenerate
```

### Content

```txt
POST   /api/sessions/{session_id}/content/generate
GET    /api/sessions/{session_id}/content
GET    /api/sessions/{session_id}/content/{item_id}
PATCH  /api/sessions/{session_id}/content/{item_id}
DELETE /api/sessions/{session_id}/content/{item_id}
```

### Validation

```txt
POST   /api/sessions/{session_id}/validate
GET    /api/sessions/{session_id}/validation-report
POST   /api/sessions/{session_id}/content/{item_id}/fix
POST   /api/sessions/{session_id}/content/fix-invalid
```

### Preview

```txt
GET    /api/sessions/{session_id}/preview
GET    /api/sessions/{session_id}/preview/{item_id}
```

### Export

```txt
POST   /api/sessions/{session_id}/export
GET    /api/sessions/{session_id}/exports
GET    /api/sessions/{session_id}/exports/{export_id}/download
```

---

## 9. Target data model

### GenerationSession

```txt
id
name
status
content_type
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
hash
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
raw_ai_output
created_at
approved_at
```

### GenerationRequest

```txt
id
session_id
amount
theme
stage
extra_prompt
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
source_generation_id
created_at
updated_at
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
updated_at
```

### ValidationReport

```txt
id
session_id
status
checked_at
summary
```

### ValidationIssue

```txt
id
report_id
item_id
severity
code
message
json_path
created_at
```

### ExportPackage

```txt
id
session_id
format
storage_path
download_name
created_at
```

---

## 10. Session statuses

```txt
draft
files_uploaded
files_analyzed
summary_pending_approval
summary_approved
concepts_generating
concepts_generated
concepts_review
concepts_approved
content_generating
content_generated
validation_running
validation_failed
validation_passed
final_review
exported
failed
cancelled
```

---

## 11. Validation engine

### Validation stages

```txt
1. JSON parse validation
2. Base structure validation
3. User schema validation
4. Required fields validation
5. Enum validation
6. Balance validation
7. Duplicate detection
8. Reference check
9. Custom rules check
10. Final validation report
```

### Issue types

```txt
error
warning
info
```

### Example error codes

```txt
INVALID_JSON
SCHEMA_MISMATCH
MISSING_REQUIRED_FIELD
INVALID_ENUM_VALUE
BALANCE_LIMIT_EXCEEDED
DUPLICATE_ID
DUPLICATE_THEME
BROKEN_REFERENCE
UNKNOWN_CONTENT_TYPE
```

### Export rule

```txt
Only the following may be exported:
- valid items,
- warning items accepted by the user.
```

---

## 12. AI strategy

### Models / costs

Use a cheaper model for:

```txt
AI understanding summary
draft concepts
human-readable preview
simple fixes
```

Use a stronger model for:

```txt
final structured JSON
complex fixes
schema-sensitive generation
```

### Cache

Cache step results:

```txt
file hash
understanding summary
draft concepts
generated content
validation result
```

Do not repeat AI calls if input has not changed.

### Prompt templates

```txt
apps/api/app/modules/ai/prompts/
  analyze_session.md
  generate_concepts.md
  generate_content.md
  fix_invalid_items.md
  generate_preview.md
```

---

## 13. LangGraph — extended version

Add LangGraph only when the plain pipeline works.

Proposed graph:

```txt
analyze_files
→ wait_for_summary_approval
→ generate_concepts
→ wait_for_concept_selection
→ generate_content
→ validate_content
→ should_fix_invalid
→ fix_invalid_items
→ validate_content
→ generate_preview
→ wait_for_final_approval
→ export_package
```

Usage:

- workflow state management,
- human-in-the-loop,
- retry/fix loops,
- resuming interrupted process,
- easier debugging of AI steps.

---

## 14. Docker setup

### MVP

```txt
services:
  web
  api

volumes:
  app_data
```

### Extended version

```txt
services:
  web
  api
  postgres
  redis
  worker
  minio optional

volumes:
  postgres_data
  redis_data
  app_data
  minio_data optional
```

If the goal is zero cost beyond the AI API, everything should run locally in Docker.

---

## 15. Proposed Makefile commands

```txt
make dev
make web
make api
make docker-up
make docker-down
make test
make lint
make format
make clean-data
make reset-db
```

---

## 16. Project folders

```txt
game-content-generator/
  apps/
    web/
      src/
        app/
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

    api/
      app/
        main.py
        config.py

        modules/
          sessions/
          files/
          ai/
          validation/
          export/
          preview/

        db/
        storage/
        common/

  docs/
    diagrams/
    product/
    architecture/
    api/

  data/
    uploads/
    exports/

  scripts/
  docker-compose.yml
  Makefile
  README.md
```

---

## 17. Roadmap

### Phase 1 — MVP

```txt
React/Vite FE
FastAPI BE
SQLite
local filesystem
simple AI pipeline
JSON/ZIP export
basic validation
```

### Phase 2 — Better product

```txt
session history
manual JSON editing
Monaco Editor
better validation reports
AI auto-fix
content presets
```

### Phase 3 — Workflow engine

```txt
LangGraph
persistent workflow state
retry/fix loops
better logs
step-level observability
```

### Phase 4 — More production-like local setup

```txt
Postgres
Redis
background worker
optional MinIO
larger file support
```

### Phase 5 — Productization

```txt
auth
team workspaces
cloud deployment
Unity/Godot presets
template library
plugin system
```

---

## 18. What matters most

Do not start with full infrastructure.

First deliver the vertical flow:

```txt
Upload files
→ AI summary
→ Generate concepts
→ Approve concepts
→ Generate JSON
→ Validate
→ Download
```

Only then add:

```txt
LangGraph
workers
Postgres
advanced validation
session history
presets
```

The biggest project risk is not lack of technology, but building too large an architecture too quickly.
