# Generate Draft Concepts — Sequence Diagram

End-to-end flow from user request to concept review.

```mermaid
sequenceDiagram
    actor User
    participant Frontend
    participant API as Backend API
    participant Session as Session Service
    participant Storage as File Storage
    participant AIOrch as AI Orchestration Service
    participant AI as AI Provider
    participant DB as Database

    User->>Frontend: Enter amount of elements to generate
    User->>Frontend: Click "Generate Concepts"

    Frontend->>API: POST generate concepts<br/>(sessionId, amount, optional notes)
    API->>DB: Load session metadata
    DB-->>API: Session metadata

    API->>Storage: Load uploaded file contents
    Storage-->>API: Parsed file contents

    API->>Session: Build session context
    Session-->>API: Session context

    API->>AIOrch: Request draft concepts prompt
    AIOrch->>AIOrch: Build prompt from context,<br/>summary, and generation config
    AIOrch->>AI: Generate draft concepts
    AI-->>AIOrch: Concepts (title, shortConcept, tags)

    AIOrch-->>API: Draft concepts response
    API->>API: Validate basic structure<br/>of draft concepts
    API->>DB: Save draft concepts
    DB-->>API: Saved concept records

    API-->>Frontend: Draft concepts list
    Frontend-->>User: Display concepts for review

    loop User review actions
        alt Accept concept
            User->>Frontend: Accept concept
            Frontend->>API: Update concept status (approved)
            API->>DB: Save status
        else Reject concept
            User->>Frontend: Reject concept
            Frontend->>API: Update concept status (rejected)
            API->>DB: Save status
        else Edit concept
            User->>Frontend: Edit title, concept, or tags
            Frontend->>API: Update concept fields
            API->>DB: Save edits
        else Regenerate concepts
            User->>Frontend: Click "Regenerate"
            Frontend->>API: POST generate concepts
            Note over API,AI: Re-runs steps 4–11
        end
    end
```

## Steps summary

| Step | Action                                                      |
| ---- | ----------------------------------------------------------- |
| 1–2  | User sets element count and triggers generation             |
| 3    | Frontend sends `sessionId`, `amount`, and optional notes    |
| 4    | Backend loads session metadata from Database                |
| 5    | Backend loads uploaded file contents from File Storage      |
| 6    | Session Service assembles session context                   |
| 7    | AI Orchestration Service builds the draft-concepts prompt   |
| 8    | AI Provider returns title, short concept, and tags per item |
| 9    | Backend validates basic structure of returned concepts      |
| 10   | Backend persists draft concepts to Database                 |
| 11   | Frontend renders concepts for user review                   |
| 12   | User accepts, rejects, edits, or regenerates concepts       |

## Regeneration note

When the user chooses **Regenerate**, the Frontend calls the same generate-concepts endpoint and the Backend repeats loading context, calling AI, validating, saving, and returning fresh draft concepts.
