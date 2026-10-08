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
- **MarkItDown installed via `pip3 install markitdown`** (pipx wasn't available on this machine)
  once we reached this slice, with the owner's explicit go-ahead first. Resolves via the
  `markitdown` CLI on `$PATH`; `MarkItDownService` wraps it the same way `GitService` wraps `git`
  -- deterministic, no LLM involvement, tested against the real CLI (free, unlike Claude Code
  calls) rather than a fake.
- **ERF -> Task Spec is one file -> one message -> one Task Spec** for this first cut, even though
  a real ERF document often contains several distinct requirements that arguably deserve separate
  specs. Splitting a single document into multiple specs is a reasonable later refinement, not
  needed to meet this phase's "Done when" bar.
- **WhatsApp export parsing assumes DD/MM/YY dates** (the more common international convention) --
  the export text itself doesn't carry the phone's locale, so a MM/DD/YY export will parse with
  day and month swapped. Supports the two common export formats (iOS bracket style, Android dash
  style); a timestamped line with no `author: body` split (WhatsApp's own system notices) is
  skipped rather than merged into a neighboring message. Known limitations, not blockers.
- **Each message is routed and imported sequentially, one real CLI call at a time** (routing, then
  extraction if routed) -- a 3-message import took about 30 seconds live. Fine for a manual,
  on-demand import of a reasonably-sized export; a much larger paste would be slow but not
  incorrect. Not parallelized in this first cut.
- **UI source creation is minimal, not a full "manage sources" screen.** The Inbox's "Import
  WhatsApp chat" action reuses one shared org-level WhatsApp source (get-or-create by kind, no
  project) -- every paste funnels into the same unrouted pool, matching the Inbox's own mental
  model and keeping re-pasting a growing export idempotent. The project list's "Import ERF
  folder..." action reuses an existing erf source for that exact folder path if one exists,
  otherwise creates one. Neither screen lists/edits/deletes sources directly; that's a reasonable
  later addition, not needed to meet this phase's "Done when" bar.
- **Manually assigning a project runs the same extraction step as auto-routing**, and only for a
  message that hasn't been processed yet -- re-assigning an already-drafted message's project
  doesn't retroactively redraft anything. Verified live: assigning a project to a message the
  owner forced through (a personal, non-work message) correctly produced an honest "this doesn't
  describe a software/work task" open question instead of fabricating a goal.

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

- [x] 1. TaskSpec model + AnalystExtractionService + manual-trigger route
- [x] 2. sources/messages data model + ERF import
- [x] 3. WhatsApp manual import + message routing with confidence
- [x] 4. Inbox + Task Spec review UI
- [x] 5. Morning briefing (dashboard extension)
