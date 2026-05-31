# Universal Game Content Generator — Domain Model

Main domain entities and their relationships.

```mermaid
classDiagram
    class GenerationSession {
        +UUID id
        +String name
        +SessionStatus status
        +DateTime createdAt
        +DateTime updatedAt
    }

    class UploadedFile {
        +UUID id
        +UUID sessionId
        +String name
        +FileRole role
        +String mimeType
        +Long size
        +String storagePath
    }

    class AIUnderstandingSummary {
        +UUID id
        +UUID sessionId
        +String detectedContentType
        +String detectedSchema
        +String detectedRules
        +String[] warnings
    }

    class GenerationRequest {
        +UUID id
        +UUID sessionId
        +Int elementCount
        +String configuration
    }

    class DraftConcept {
        +UUID id
        +UUID sessionId
        +String title
        +String shortConcept
        +String[] tags
        +ConceptStatus status
    }

    class GeneratedContentItem {
        +UUID id
        +UUID sessionId
        +UUID conceptId
        +String contentType
        +JSON jsonData
        +ItemStatus status
    }

    class ValidationReport {
        +UUID id
        +UUID sessionId
        +ReportStatus status
        +DateTime checkedAt
    }

    class ValidationIssue {
        +UUID id
        +UUID itemId
        +Severity severity
        +String message
        +String path
    }

    class ExportPackage {
        +UUID id
        +UUID sessionId
        +ExportFormat format
        +String downloadUrl
        +DateTime createdAt
    }

    class FileRole {
        <<enumeration>>
        PROJECT_CONTEXT
        BALANCE_RULES
        EXISTING_CONTENT
        OUTPUT_SCHEMA
        EXAMPLES
        ADDITIONAL_NOTES
    }

    class SessionStatus {
        <<enumeration>>
        CREATED
        FILES_UPLOADED
        ANALYZING
        AWAITING_APPROVAL
        GENERATING_CONCEPTS
        GENERATING_CONTENT
        VALIDATING
        READY_FOR_REVIEW
        EXPORTED
        ARCHIVED
    }

    class ExportFormat {
        <<enumeration>>
        JSON
        ZIP
    }

    GenerationSession "1" --> "*" UploadedFile : has
    GenerationSession "1" --> "1" AIUnderstandingSummary : has
    GenerationSession "1" --> "1" GenerationRequest : has
    GenerationSession "1" --> "*" DraftConcept : has
    GenerationSession "1" --> "*" GeneratedContentItem : has
    GenerationSession "1" --> "*" ValidationReport : has
    GenerationSession "1" --> "*" ExportPackage : has

    UploadedFile --> FileRole : role

    DraftConcept "1" --> "0..1" GeneratedContentItem : becomes

    GeneratedContentItem "1" --> "*" ValidationIssue : has
    ValidationReport "1" --> "*" ValidationIssue : contains

    ExportPackage --> ExportFormat : format
    GenerationSession --> SessionStatus : status
```

## Entity overview

| Entity | Purpose |
|--------|---------|
| GenerationSession | Root aggregate for a single content generation workflow |
| UploadedFile | User-provided project file stored and assigned a role |
| FileRole | Category that tells AI how to interpret each file |
| AIUnderstandingSummary | AI interpretation of uploaded files, schema, and rules |
| GenerationRequest | User configuration for how many items to generate |
| DraftConcept | Lightweight concept (title, summary, tags) awaiting approval |
| GeneratedContentItem | Full structured JSON output for an approved concept |
| ValidationReport | Result of validating generated content for a session |
| ValidationIssue | Single validation error or warning on a content item |
| ExportPackage | Downloadable JSON or ZIP artifact for a completed session |

## Key relationships

- Only **approved** draft concepts become **GeneratedContentItem** records.
- **GeneratedContentItem.jsonData** is the source of truth; preview and export derive from it.
- **ValidationIssue** records link to both a **GeneratedContentItem** and the **ValidationReport** that recorded them.
- A session may produce multiple **ValidationReport** entries as content is fixed and revalidated.
- A session may produce multiple **ExportPackage** records (e.g. JSON-only and full ZIP).

## Supporting enumerations

**ConceptStatus:** `pending`, `approved`, `rejected`, `edited`

**ItemStatus:** `draft`, `valid`, `invalid`, `fixed`

**ReportStatus:** `passed`, `failed`, `partial`

**Severity:** `error`, `warning`, `info`
