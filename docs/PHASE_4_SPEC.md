# Phase 4 Spec

Creative: turn a Task Spec into a Design Spec (screens, states, navigation) and a Mermaid
user/screen flow diagram with requirement IDs on nodes, rendered in the app.

## Decisions

- **Scope cut: no screen code generation in this phase.** AGENTS.md marks screen code as
  explicitly optional for Creative, and it needs writing real code into a target repo -- the
  git-worktree + Claude Code (`Edit`/`Bash` tools) mechanism that's actually Phase 5's job. Building
  a second, Creative-only code-writing path now would mean merging it with or rebuilding it against
  Phase 5's Developer mechanism later. Screen code + golden-test screenshots move to whenever
  Phase 5's coding infra exists.
- **Scope cut: no design system package or Widgetbook scaffolding.** Per `ARCHITECTURE.md` §8 the
  design system is per-organization and lives in the *target* project's ecosystem, not inside
  Agentic -- there's no real one to build or validate against yet. `Project.designSystemRef`
  (already in `core`) is passed into Creative's prompt as plain context ("only use components from
  this package"); Agentic itself never generates a design-system package or catalog.
- **Design Spec + Mermaid diagram come from one Claude Code CLI call, not two.** Same one-shot
  `-p --json-schema --tools ""` pattern as `AnalystExtractionService`/`MessageRoutingService`, not
  a chat turn. One call keeps the diagram's screens/navigation in sync with the spec's screens --
  generating them separately risks the two disagreeing with each other. The schema returns both a
  `designSpec` object and a `mermaid` string; the server splits them into two separate `Artifact`s
  (`kind: designSpec`, `kind: diagram`) after the call, same "structured handoffs" rule as every
  other artifact pair.
- **Both new artifact kinds are project-scoped**, matching the precedent `TaskSpec` already set in
  Phase 3 (not task-scoped, since a draft design has no `Task` yet -- that only exists once a human
  decides to act on it). `Artifact`'s doc comment is updated to reflect this; `designSpec`/`diagram`
  were originally documented as task-scoped kinds before Phase 3/4 established otherwise.
- **Input is an existing Task Spec artifact, not raw text.** `POST .../design-specs/generate` takes
  a `taskSpecArtifactId` (one of the project's already-drafted Task Specs, from Phase 3's pipeline)
  rather than re-accepting raw ERF/message text -- keeps the traceability chain explicit (ERF ->
  Message -> Task Spec -> Design Spec/diagram) and avoids a second extraction path duplicating
  Phase 3's.
- **Mermaid rendering is `webview_flutter` + a vendored `mermaid.js`, not a native Dart renderer.**
  The two available native packages (`flutter_mermaid`, `duskmoon_mermaid_renderer`) are both
  early-stage with narrow flowchart support -- real risk of mis-rendering valid Mermaid the model
  generates. A local HTML asset bundling `mermaid.js` gives full fidelity for whatever the model
  produces and needs no network access once vendored. `webview_flutter_wkwebview` supports macOS.
- **Design Spec model** (per `AGENTS.md`'s Creative section): a list of screens, each with a short
  purpose, a fixed set of UI states (`empty`/`loading`/`error`/`success` -- the four AGENTS.md
  names explicitly), and the names of screens it navigates to. Requirement IDs are carried over
  from the source Task Spec for traceability, not re-derived.

## Build order

1. `core.DesignSpec` model + `CreativeExtractionService` (one-shot CLI call producing both the
   spec and the Mermaid text) + a `POST .../design-specs/generate` route (takes a
   `taskSpecArtifactId`) + `GET` list routes for both new artifact kinds.
2. A reusable `MermaidView` widget: `webview_flutter` + a vendored `mermaid.js` asset, rendering
   arbitrary Mermaid source.
3. UI: a Design Spec + diagram review dialog on the project list (mirrors the existing Task Spec
   dialog), with a "Generate from Task Spec..." action that picks one of the project's drafted
   Task Specs and renders the resulting diagram inline via `MermaidView`.

**Done when** (from ROADMAP.md): "make a flow diagram of feature X from this ERF" works end to
end -- i.e. the full chain from Phase 3's ERF import through to a rendered diagram in the app.

## Progress

(Update after each approved slice.)

- [x] 1. DesignSpec model + CreativeExtractionService + generate/list routes
- [ ] 2. MermaidView widget (webview_flutter + vendored mermaid.js)
- [ ] 3. Design Spec + diagram review UI, wired end to end
