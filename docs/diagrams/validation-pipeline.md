# Universal Game Content Generator — Validation Pipeline

Validation process applied after AI generates structured JSON.

**Rule:** Only valid items or items with explicitly accepted warnings can be exported.

```mermaid
flowchart TD
    Input["Generated structured JSON"]

    V1["1. Parse JSON"]
    V2["2. Validate base JSON structure"]
    V3["3. Validate against schema"]
    V4["4. Check required fields"]
    V5["5. Check allowed enum values"]
    V6["6. Validate balance rules"]
    V7["7. Check duplicates"]
    V8["8. Check references to existing content"]
    V9["9. Create validation report"]
    V10["10. Mark items as valid, warning, or invalid"]

    Input --> V1 --> V2 --> V3 --> V4 --> V5 --> V6 --> V7 --> V8 --> V9 --> V10

    V10 --> Outcome{"Item outcome?"}

    Outcome -->|"Valid"| Valid["Valid item"]
    Outcome -->|"Warning"| Warning["Warning item"]
    Outcome -->|"Invalid"| Invalid["Invalid item"]

    Valid --> Preview["Final preview"]
    Warning --> Accept{"User accepts warning?"}
    Accept -->|"Yes"| Preview
    Accept -.->|"No"| Fix

    Invalid --> Fix{"Fix strategy"}
    Fix -->|"AI auto-fix"| AutoFix["AI patches JSON"]
    Fix -->|"Manual edit"| ManualFix["User edits JSON"]

    AutoFix -.-> Input
    ManualFix -.-> Input

    Preview --> ExportGate{"Valid or accepted warning?"}
    ExportGate -->|"Yes"| Export["Export package"]
    ExportGate -.->|"No — fix required"| Fix
```

## Pipeline steps

| Step | Check |
|------|-------|
| 1 | Parse JSON — syntactic parsing of raw output |
| 2 | Base JSON structure — objects, arrays, types |
| 3 | Schema validation — match uploaded output schema |
| 4 | Required fields — all mandatory properties present |
| 5 | Enum values — values within allowed sets |
| 6 | Balance rules — limits, formulas, caps from balance files |
| 7 | Duplicates — IDs, names, or keys already in session or existing content |
| 8 | References — foreign keys point to real existing content |
| 9 | Validation report — aggregate results per item and session |
| 10 | Item status — classify each item as valid, warning, or invalid |

## Outcome paths

| Outcome | Next step |
|---------|-----------|
| Valid | Proceed to final preview and export |
| Warning | User must explicitly accept before preview or export |
| Invalid | AI auto-fix or manual edit, then re-enter validation |

Fix loops return updated JSON to the start of the pipeline (step 1).
