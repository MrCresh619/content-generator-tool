# Universal Game Content Generator — Product Flow

Main user-facing generation process from session creation to export.

**Principle:** Structured JSON is the source of truth. The human-readable preview is always generated from JSON, never the other way around.

```mermaid
flowchart TD
    S1["1. Create generation session"]
    S2["2. Upload project files"]
    S3["3. Assign file roles"]
    S4["4. AI analyzes uploaded files"]
    S5["5. AI shows understanding summary"]
    S6["6. User approves summary or adds corrections"]
    S7["7. User sets number of elements to generate"]
    S8["8. AI generates draft concepts"]
    S9["9. User accepts, rejects, or edits concepts"]
    S10["10. AI generates structured JSON"]
    JSON["Structured JSON — source of truth"]
    S11["11. System validates content"]
    S12["12. User reviews human-readable preview from JSON"]
    S13["13. User downloads JSON or ZIP"]

    S1 --> S2 --> S3 --> S4 --> S5 --> S6
    S6 --> S7 --> S8 --> S9 --> S10 --> JSON
    JSON --> S11 --> S12 --> S13

    S6 -.->|"Corrections"| S4
    S9 -.->|"Reject or regenerate"| S8
    S11 -.->|"Fix and revalidate"| S10
```
