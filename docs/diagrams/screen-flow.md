# Universal Game Content Generator — Screen Flow

Main screens and navigation paths through the web application.

```mermaid
flowchart TD
    Home["Home / Landing Page"]
    History["Session History"]
    NewSession["New Generation Session"]
    Upload["Upload Files"]
    Roles["Assign File Roles"]
    Understanding["AI Understanding Summary"]
    Setup["Generation Setup"]
    Concepts["Concept Selection"]
    Generating["Content Generation"]
    Validation["Validation Results"]
    Review["Final Review"]
    Export["Export"]

    Home --> NewSession
    Home --> History

    NewSession --> Upload
    Upload --> Roles
    Roles --> Understanding
    Understanding --> Setup
    Setup --> Concepts
    Concepts --> Generating
    Generating --> Validation
    Validation --> Review
    Review --> Export

    Export --> Home
    History --> Home
    History -->|"Continue session"| Upload

    Understanding -.->|"Revise files"| Upload
    Understanding -.->|"Edit notes"| Roles

    Concepts -.->|"Regenerate concepts"| Concepts

    Review -.->|"Edit selected items"| Validation
```

## Navigation notes

| From | Loop | Destination |
|------|------|-------------|
| AI Understanding Summary | Revise files | Upload Files |
| AI Understanding Summary | Edit notes | Assign File Roles |
| Concept Selection | Regenerate concepts | Concept Selection (same screen) |
| Final Review | Edit selected items | Validation Results |

Session History lets users browse past sessions, return home, or continue an in-progress session from Upload Files.
