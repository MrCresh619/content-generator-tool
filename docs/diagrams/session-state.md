# Universal Game Content Generator — Session State

Lifecycle states and transitions for a `GenerationSession`.

```mermaid
stateDiagram-v2
    [*] --> Draft

    state ActiveSession {
        Draft --> FilesUploaded
        FilesUploaded --> FilesAnalyzed
        FilesAnalyzed --> SummaryPendingApproval

        SummaryPendingApproval --> SummaryRejected
        SummaryRejected --> FilesAnalyzed

        SummaryPendingApproval --> SummaryApproved

        SummaryApproved --> ConceptsGenerating
        ConceptsGenerating --> ConceptsGenerated
        ConceptsGenerated --> ConceptsReview

        ConceptsReview --> ConceptsGenerating : Regenerate concepts
        ConceptsReview --> ConceptsApproved : Enough concepts approved

        ConceptsApproved --> ContentGenerating
        ContentGenerating --> ContentGenerated
        ContentGenerated --> ValidationRunning

        ValidationRunning --> ValidationFailed
        ValidationFailed --> ContentGenerating : AI auto-fix
        ValidationFailed --> ContentGenerated : Manual edit

        ValidationRunning --> ValidationPassed
        ValidationPassed --> FinalReview

        FinalReview --> ContentGenerating : Edit selected items
    }

    FinalReview --> Exported

    ActiveSession --> Failed : Unrecoverable error
    ActiveSession --> Cancelled : User cancels

    Exported --> [*]
    Failed --> [*]
    Cancelled --> [*]
```

## State groups

| Group                | States                                                                                     |
| -------------------- | ------------------------------------------------------------------------------------------ |
| Setup                | Draft, FilesUploaded, FilesAnalyzed                                                        |
| AI understanding     | SummaryPendingApproval, SummaryRejected, SummaryApproved                                   |
| Concepts             | ConceptsGenerating, ConceptsGenerated, ConceptsReview, ConceptsApproved                    |
| Content & validation | ContentGenerating, ContentGenerated, ValidationRunning, ValidationFailed, ValidationPassed |
| Completion           | FinalReview, Exported                                                                      |
| Terminal             | Exported, Failed, Cancelled                                                                |

## Transition notes

- **SummaryRejected** returns to **FilesAnalyzed** so the user can revise files or notes and re-run analysis.
- **ConceptsReview → ConceptsGenerating** supports regenerating draft concepts without leaving the review step permanently.
- **ValidationFailed** may return via AI auto-fix (**ContentGenerating**) or manual edit (**ContentGenerated**, then re-validation).
- **FinalReview → ContentGenerating** allows editing selected items before export.
- **Failed** and **Cancelled** are reachable from any state inside **ActiveSession** (all non-terminal workflow states).

## Terminal states

| State     | Meaning                                               |
| --------- | ----------------------------------------------------- |
| Exported  | Session completed; JSON or ZIP available for download |
| Failed    | Unrecoverable error halted the session                |
| Cancelled | User explicitly cancelled an in-progress session      |
