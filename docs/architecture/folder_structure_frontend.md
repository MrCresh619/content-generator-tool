# Folder Structure — Frontend

Recommended frontend structure for a modular React + Vite application.

```txt
apps/web/
  src/
    app/
      main.tsx
      router.tsx
      providers.tsx
      layout.tsx

    pages/
      home/
        HomePage.tsx

      sessions/
        NewSessionPage.tsx
        SessionSetupPage.tsx
        AIUnderstandingPage.tsx
        ConceptSelectionPage.tsx
        GeneratedContentPage.tsx
        ValidationPage.tsx
        ExportPage.tsx
        SessionHistoryPage.tsx

    features/
      sessions/
        api/
          sessionsApi.ts
        model/
          types.ts
          schemas.ts
        hooks/
          useCreateSession.ts
          useSession.ts
          useSessionList.ts
        components/
          SessionStatusBadge.tsx
          SessionStepper.tsx
          SessionHeader.tsx

      files/
        api/
          filesApi.ts
        model/
          types.ts
          schemas.ts
        hooks/
          useUploadFiles.ts
          useAssignFileRole.ts
          useSessionFiles.ts
        components/
          FileUploadDropzone.tsx
          FileRoleSelector.tsx
          UploadedFilesList.tsx
          UploadedFileCard.tsx

      understanding/
        api/
          understandingApi.ts
        model/
          types.ts
          schemas.ts
        hooks/
          useAnalyzeSession.ts
          useUnderstandingSummary.ts
          useApproveUnderstanding.ts
        components/
          UnderstandingSummaryCard.tsx
          UnderstandingWarnings.tsx
          CorrectionNotesForm.tsx
          DetectedSchemaPreview.tsx

      concepts/
        api/
          conceptsApi.ts
        model/
          types.ts
          schemas.ts
        hooks/
          useGenerateConcepts.ts
          useConceptActions.ts
          useConceptList.ts
        components/
          ConceptCard.tsx
          ConceptList.tsx
          ConceptEditorDialog.tsx
          ConceptStatusFilter.tsx
          ConceptGenerationForm.tsx

      generated-content/
        api/
          generatedContentApi.ts
        model/
          types.ts
          schemas.ts
        hooks/
          useGenerateContent.ts
          useGeneratedContent.ts
          useUpdateGeneratedItem.ts
        components/
          GeneratedItemCard.tsx
          GeneratedJsonEditor.tsx
          GeneratedContentList.tsx
          GeneratedContentToolbar.tsx

      validation/
        api/
          validationApi.ts
        model/
          types.ts
          schemas.ts
        hooks/
          useRunValidation.ts
          useValidationReport.ts
        components/
          ValidationSummary.tsx
          ValidationIssueList.tsx
          ValidationIssueCard.tsx
          ValidationStatusBadge.tsx

      preview/
        api/
          previewApi.ts
        model/
          types.ts
        hooks/
          usePreview.ts
        components/
          HumanReadablePreview.tsx
          PreviewItem.tsx
          PreviewToolbar.tsx

      export/
        api/
          exportApi.ts
        model/
          types.ts
          schemas.ts
        hooks/
          useCreateExport.ts
          useDownloadExport.ts
          useExportList.ts
        components/
          ExportOptions.tsx
          ExportPackageCard.tsx
          ExportActions.tsx

    shared/
      api/
        client.ts
        errors.ts
        generated/
          schema.ts
          types.ts

      components/
        ui/
          Button.tsx
          Card.tsx
          Dialog.tsx
          Input.tsx
          Select.tsx
          Textarea.tsx
          Badge.tsx
          Tabs.tsx
          Toast.tsx

        layout/
          AppShell.tsx
          PageHeader.tsx
          PageContainer.tsx

        feedback/
          LoadingState.tsx
          ErrorState.tsx
          EmptyState.tsx

      hooks/
        useDebounce.ts
        useConfirmDialog.ts
        useToast.ts

      lib/
        cn.ts
        formatDate.ts
        downloadFile.ts
        parseJsonSafe.ts

      types/
        common.ts
        api.ts

      constants/
        fileRoles.ts
        sessionStatuses.ts
        validationStatuses.ts

    styles/
      globals.css

  public/
    favicon.svg

  package.json
  vite.config.ts
  tsconfig.json
  README.md
```

## Frontend architecture style

Use feature-based architecture.

Recommended import direction:

```txt
pages → features → shared
```

Rules:

```txt
pages can import features
features can import shared
shared cannot import features
features should not import each other directly unless there is a clear reason
```

If two features need to cooperate, compose them on the page level.

Example:

```txt
ConceptSelectionPage
  imports:
    concepts feature
    sessions feature
```

Do not make:

```txt
concepts imports generated-content
generated-content imports validation
validation imports concepts
```

That creates tight coupling.

## Feature module structure

Each feature should follow this shape:

```txt
features/example-feature/
  api/
    exampleApi.ts
  model/
    types.ts
    schemas.ts
  hooks/
    useExample.ts
  components/
    ExampleCard.tsx
    ExampleList.tsx
```

### api

Contains calls to backend API.

### model

Contains types and Zod schemas related to the feature.

### hooks

Contains React Query hooks and feature-specific hooks.

### components

Contains UI components that belong to the feature.

## Shared folder rules

Use `shared` only for truly reusable things.

Allowed:

```txt
shared/api/client.ts
shared/components/ui/Button.tsx
shared/components/layout/AppShell.tsx
shared/lib/formatDate.ts
shared/types/common.ts
```

Avoid putting domain components in shared.

Do not put there:

```txt
ConceptCard
SessionStepper
ValidationIssueList
UploadedFilesList
```

Those belong to their feature modules.

## MVP frontend libraries

```txt
react
vite
typescript
@tanstack/react-query
react-router-dom
react-hook-form
zod
tailwindcss
lucide-react
```

## Optional / later frontend libraries

```txt
shadcn/ui
monaco-editor
date-fns
zustand
```

Use Zustand only if local UI state becomes difficult to manage. Do not add it at the beginning unless needed.
