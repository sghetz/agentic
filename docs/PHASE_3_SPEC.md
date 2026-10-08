# Phase 3 Spec

Analyst and ingestion: raw work messages (documents and chat exports) become reviewable Task
Specs without manual copying, via the same "Claude Code CLI, one-shot, structured output" pattern
Health's diagnosis already proved in Phase 1.

## Decisions

- **Scope for this phase: ERF import and WhatsApp manual import only.** Slack and Google Chat both
  need live OAuth/API tokens from the owner's own accounts before they can be built or tested
  meaningfully; the owner chose to defer both rather than wire up credentials for a platform that
  might not even be in daily use. ERF (local files) and WhatsApp (manual export/paste) need no
  external account at all, so the full message -> routing -> Task Spec pipeline can be built and
  tested end-to-end right away. Slack/Google Chat become a later addition once this core pipeline
  is proven -- the `sources`/`messages` schema already has a `kind` column for them, so adding a
  source type later doesn't require a schema change.
- **Task Spec is a versioned project-scoped Artifact** (`kind: taskSpec`), not a new top-level
  table -- same pattern Health Reports already established in Phase 1 (`createProjectArtifact`
  already auto-increments version per kind+project). Shape per `docs/AGENTS.md`'s Analyst section:
  goal, requirement IDs, acceptance criteria, affected areas, priority, open questions. The
  Analyst never invents a missing requirement -- anything unclear becomes an open question instead
  of a guess.
- **Extraction and routing are one-shot Claude Code CLI calls, not chat turns** -- modeled directly
  on `FailureDiagnosisService` from Phase 1 (`-p`, `--json-schema`, `--tools ""`, no session), not
  on Phase 2's conversational `ClaudeConversationService`. A message arriving is a background/
  on-demand event, not a back-and-forth; there's no conversation to resume.
- **`sources`/`messages` schema** matches `ARCHITECTURE.md` section 4 exactly: a source's
  `projectId` is set when it's already tied to one project (e.g. an ERF folder configured for that
  project) and null when it's an org-level source that needs per-message routing (e.g. a shared
  WhatsApp group discussing multiple projects). Routing only runs for the null case.
- **Routing confidence threshold**: a message with `routingConfidence >= 0.7` is auto-routed and
  immediately queued for Task Spec extraction; below that, it's stored unrouted for the owner to
  assign a project manually. No separate "needs review" status enum -- a message is unrouted
  simply when `routedProjectId` is still null.
- **No scheduler yet.** `ARCHITECTURE.md` lists ingestion as one of the `cron` scheduler's jobs,
  but Health checks stayed purely on-demand through all of Phase 1 despite the manifest example's
  unused `health.schedule` field -- same precedent applies here. Ingestion (ERF folder scan,
  WhatsApp import) is triggered on demand (a button/endpoint), not polled on a timer. Introducing
  `cron` is deferred to whenever a source actually needs background polling (Slack/Google Chat).
- **Morning briefing reuses the existing all-org `GET /dashboard`**, not a new screen --
  `DashboardSummary` already assembles every org's data in memory from separate per-org reads
  (built in Phase 0), which is exactly the "morning briefing" shape. It gains unrouted-message and
  draft-Task-Spec counts per org; still request-time computed, not cached or scheduled.
- **MarkItDown is not yet installed** on this machine (`markitdown` CLI absent, `pip show
  markitdown` empty). Not needed until the ERF slice -- will confirm with the owner how to get it
  installed (`pipx install markitdown` is the usual route) when we get there, rather than installing
  a new Python package without asking first.
- **ERF -> Task Spec is one file -> one message -> one Task Spec** for this first cut, even though
  a real ERF document often contains several distinct requirements that arguably deserve separate
  specs. Splitting a single document into multiple specs is a reasonable later refinement, not
  needed to meet this phase's "Done when" bar.

## Build order

1. `core.TaskSpec` model + `AnalystExtractionService` (one-shot CLI, modeled on
   `FailureDiagnosisService`) + a route to manually trigger extraction from raw text, no
   sources/messages model yet -- smallest possible slice, directly testable in isolation.
2. `sources`/`messages` data model + ERF import (MarkItDown external CLI) -- first real end-to-end
   ingestion pipeline, still fully local and credential-free. (Needs MarkItDown installed first.)
3. WhatsApp manual import (paste/upload an exported chat, parsed into individual messages) +
   message routing with confidence, using the same extraction service from slice 1.
4. UI: an inbox for unrouted messages needing a project assigned, and a review screen for draft
   Task Specs.
5. Morning briefing: extend `DashboardSummary`/`GET /dashboard` with unrouted-message and
   draft-Task-Spec counts per org.

**Done when** (from ROADMAP.md): new work messages become reviewable Task Specs without manual
copying.

## Progress

(Update after each approved slice.)

- [ ] 1. TaskSpec model + AnalystExtractionService + manual-trigger route
- [ ] 2. sources/messages data model + ERF import
- [ ] 3. WhatsApp manual import + message routing with confidence
- [ ] 4. Inbox + Task Spec review UI
- [ ] 5. Morning briefing (dashboard extension)
