# Generate Full Structured Content — Sequence Diagram

End-to-end flow from approved concepts to validated JSON and preview.

**Principle:** Structured JSON is the source of truth. Human-readable preview is generated only after validation, from JSON — never the other way around.

```mermaid
sequenceDiagram
    actor User
    participant Frontend
    participant API as Backend API
    participant Session as Session Service
    participant AIOrch as AI Orchestration Service
    participant AI as AI Provider
    participant Validation as Validation Engine
    participant DB as Database

    User->>Frontend: Approve selected draft concepts
    Frontend->>API: POST generate content<br/>(sessionId, approvedConceptIds)

    API->>DB: Load approved concepts
    DB-->>API: Approved concepts

    API->>Session: Load session context
    Session->>DB: Load session metadata and file roles
    DB-->>Session: Session metadata
    Session-->>API: Session context<br/>(project context, balance rules,<br/>existing content, schema, examples)

    API->>AIOrch: Request full content generation
    AIOrch->>AIOrch: Build prompt from approved concepts,<br/>project context, balance rules,<br/>existing content, output schema or examples
    AIOrch->>AI: Generate structured JSON items
    AI-->>AIOrch: Structured JSON per concept
    AIOrch-->>API: Generated JSON items

    API->>Validation: Validate generated JSON
    Validation->>Validation: Check JSON, schema, balance,<br/>duplicates, and references
    Validation-->>API: Validation report<br/>(valid, warning, invalid per item)

    API->>DB: Store generated items and validation report
    DB-->>API: Saved records

    API-->>Frontend: Generated items and validation results
    Frontend-->>User: Display validation results

    alt Invalid items exist
        User->>Frontend: Trigger AI auto-fix or manual edit
        Frontend->>API: PATCH item JSON or POST auto-fix
        API->>AIOrch: Request JSON patch (auto-fix only)
        AIOrch->>AI: Fix invalid JSON items
        AI-->>AIOrch: Corrected JSON
        AIOrch-->>API: Corrected items
        API->>Validation: Re-validate updated JSON
        Validation-->>API: Updated validation report
        API->>DB: Store items and report
        API-->>Frontend: Updated validation results
    else Validation passes
        API-->>Frontend: Valid JSON items
        Frontend->>Frontend: Generate human-readable preview from JSON
        Frontend-->>User: Show final preview (derived from JSON)
    end
```

## Steps summary

| Step | Action                                                                             |
| ---- | ---------------------------------------------------------------------------------- |
| 1–2  | User approves concepts; Frontend sends approved concept IDs                        |
| 3    | Backend loads approved concepts and session context                                |
| 4    | AI Orchestration builds prompt from concepts, context, rules, schema, and examples |
| 5    | AI Provider returns structured JSON items                                          |
| 6    | Backend sends generated JSON to Validation Engine                                  |
| 7    | Validation Engine checks JSON, schema, balance, duplicates, and references         |
| 8    | Backend stores generated items and validation report in Database                   |
| 9    | Frontend displays validation results                                               |
| 10   | Invalid items: user triggers AI auto-fix or manual edit, then re-validation        |
| 11   | On pass: Frontend renders preview from JSON only                                   |

## Data flow note

```
Approved concepts → AI → Structured JSON → Validation → Database → Preview (from JSON)
```

Preview and export always read from stored **jsonData**; they never drive content generation.
