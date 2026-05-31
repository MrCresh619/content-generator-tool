# Universal Game Content Generator — Data Flow

How data moves from uploaded files to exported JSON or ZIP.

**Rule:** Structured JSON is the source of truth. Human-readable preview is always generated from JSON, never the other way around.

```mermaid
flowchart TD
    D1["1. Uploaded files"]
    D2["2. Parsed file contents"]
    D3["3. Session context"]
    D4["4. AI understanding summary"]
    D5["5. User corrections"]
    D6["6. Generation configuration"]
    D7["7. Draft concepts"]
    D8["8. Approved concepts"]
    Rejected["Rejected concepts"]
    D9["9. Structured generated JSON"]
    D10["10. Validation report"]
    Invalid["Invalid generated items"]
    Valid["Valid generated items"]
    D11["11. Human-readable preview from JSON"]
    D12["12. Export package"]

    D1 --> D2 --> D3
    D3 --> D4
    D4 --> D5
    D5 --> D6
    D6 --> D7

    D7 --> D8
    D7 --> Rejected

    D8 --> D9
    D9 --> D10
    D10 --> Valid
    D10 --> Invalid

    Valid --> D11
    Valid --> D12

    D9 -.->|"Source of truth for preview"| D11

    D5 -.->|"Refine understanding"| D4
    D7 -.->|"Regenerate drafts"| D7
    Invalid -.->|"Fix or regenerate"| D9
```

## Stage descriptions

| Stage | Description |
|-------|-------------|
| Uploaded files | Raw project files with assigned roles |
| Parsed file contents | Extracted text and structured data from uploads |
| Session context | Combined session state, file metadata, and roles |
| AI understanding summary | AI interpretation of project files and constraints |
| User corrections | User-approved or edited understanding |
| Generation configuration | Element count, content type, and generation settings |
| Draft concepts | Title, short concept, and tags per item |
| Approved concepts | Concepts accepted for full JSON generation |
| Structured generated JSON | Source-of-truth content output |
| Validation report | Schema, balance, duplicate, and reference check results |
| Human-readable preview from JSON | Display layer derived only from valid JSON |
| Export package | JSON or ZIP with content, manifest, report, and summary |

## Branching rules

- **Rejected concepts** are discarded and never enter full content generation.
- **Invalid generated items** loop back to fixing or regeneration until they pass validation.
- **Valid generated items** proceed to human-readable preview and export.
- **Preview and export** always read from structured JSON, not from free-form text.
