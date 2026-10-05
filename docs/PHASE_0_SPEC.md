# Phase 0 Spec

All decisions below are final for Phase 0. Do not add AI, agents, ingestion, or health checks yet.

## Workspace
- Dart pub workspace at the repo root (Dart 3.6+), three packages:
  - packages/core   (pure Dart, no Flutter, no server-only deps)
  - packages/server (pure Dart backend)
  - packages/app    (Flutter macOS only)
- Lints: package:lints recommended (core, server) and flutter_lints (app). Must be analyze-clean.

## packages/core
- Immutable models with freezed + json_serializable:
  Organization, Project, ProjectLink, Task, TaskEvent, Artifact, plus enums:
  OrgType (employer, personal, client), ProjectStatus (active, paused, archived),
  LinkRelation (dependsOn, sharesCodeWith, related),
  TaskStatus (newTask, specified, inDesign, inDevelopment, inReview, awaitingApproval, done, blocked),
  TaskEventType (created, statusChanged, commented, reopened, artifactAttached, edited),
  Actor (user, or agent with a role name), ArtifactKind (taskSpec, designSpec, diagram, healthReport, pr, review).
- IDs: UUID v7 strings. Timestamps: UTC, ISO 8601 in JSON.
- Task status state machine lives in core (pure function). Allowed transitions:
  newTask -> specified -> inDesign -> inDevelopment -> inReview -> awaitingApproval -> done.
  inDesign may be skipped. blocked is reachable from any non-done state and returns to the
  previous state. done can only change via a reopened event (returns to specified).
- Task state is derived by folding events: pure functions deriveTask(events) and
  deriveTaskAt(events, DateTime at) for "what did this task look like on date X".
- Shared API request/response DTOs also live here so the app and server use the same types.

## packages/server
- shelf + shelf_router, bound to 127.0.0.1 only, port 8787 (configurable).
- Storage with drift (NativeDatabase):
  - registry.db: organizations and global settings only.
  - one data.db per organization: projects, project_links, tasks, task_events, artifacts.
  - Data dir: ~/Library/Application Support/Agentic/ (registry.db, orgs/<orgId>/data.db).
    The data dir is injectable so tests use a temp directory.
- Repository layer: OrgStore opened per orgId. No method anywhere takes two orgIds or queries
  across org databases. The dashboard reads each org DB separately and merges summaries in memory.
- task_events is append-only (no update or delete). tasks.currentStatus and updatedAt are a
  cache, rewritten from the event fold inside the same transaction as each event insert.
- Every event records actor and timestamp. Comments and edits are events too.
- Endpoints (JSON, using core DTOs):
  ```
  GET/POST        /orgs
  GET/PATCH       /orgs/{orgId}
  GET/POST        /orgs/{orgId}/projects
  GET/PATCH       /orgs/{orgId}/projects/{projectId}
  POST            /orgs/{orgId}/projects/{projectId}/archive
  GET/POST/DELETE /orgs/{orgId}/projects/{projectId}/links
  GET/POST        /orgs/{orgId}/projects/{projectId}/tasks   (filters: status, from, to, q)
  GET             /orgs/{orgId}/tasks/{taskId}               (optional ?at=ISO date: derived state then)
  GET/POST        /orgs/{orgId}/tasks/{taskId}/events
  GET/POST        /orgs/{orgId}/tasks/{taskId}/artifacts
  GET             /dashboard                                  (per-org counts by status, recent activity)
  GET             /health
  ```
- Project links may only reference projects in the same org; reject otherwise.
- Invalid status transitions return 409 with the allowed transitions.
- An ID that exists in another org must behave exactly like a nonexistent ID (404).
- Structured logging; never log request bodies that could later hold secrets.

## packages/app
- Flutter macOS, App Sandbox disabled in both entitlement files, network client allowed.
- Riverpod (riverpod_annotation + code generation) for state. go_router for navigation.
- API client in its own layer using core DTOs; widgets never call HTTP directly.
- Layout: left sidebar with org switcher (top) and project list (below, with archived toggle);
  main area with tabs: Tasks, Dashboard.
  - Task list: filter by status, date range, text search; create task.
  - Task detail: current state, full event timeline (newest first), add comment,
    change status (only allowed transitions shown), reopen, attach artifact (URI + kind),
    and a "view as of date" picker that shows the derived state at that date.
  - Org and project create/edit dialogs; archive project.
  - Dashboard: all orgs, counts by status, recent activity; read-only.
- Clear empty, loading, and error states. Light and dark theme from system.

## Tests (required before UI work)
- core: state machine transitions, deriveTask and deriveTaskAt folding, JSON round trips.
- server: repository CRUD; event append-only guarantee; status cache equals fold result;
  ORG ISOLATION: two orgs with data, prove org A store/routes can never read, link to,
  or modify anything in org B, including by guessing B's IDs; dashboard reads both
  correctly without mixing records.
- app: widget tests for task detail timeline and status change controls.

## Build order (stop after each slice for review and commit)
1. Workspace + core models + state machine + tests
2. drift storage + repositories + isolation tests
3. Server routes + route tests
4. Flutter app shell (sidebar, org/project management)
5. Task list + task detail + timeline + as-of-date view
6. Dashboard

After each slice: run dart analyze, dart format, and all tests; report results.
Keep the Commands section of CLAUDE.md updated as commands become real.
When Phase 0's "Done when" in ROADMAP.md is met, say so; update the Current phase line
only after the owner confirms.

## Progress
(Update after each approved slice.)
- [x] 1. Workspace + core
- [x] 2. Storage + isolation tests
- [x] 3. Server routes
- [x] 4. App shell
- [x] 5. Tasks UI
- [x] 6. Dashboard
