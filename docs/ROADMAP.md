# Roadmap

Each phase ends with something usable. Do not start a phase until the previous one's
"Done when" is met. Update the Status line as work progresses.

**Current phase: 5**

## Phase 0: Foundations (no AI yet)

- Dart pub workspace: `packages/core`, `packages/server` (shelf), `packages/app` (Flutter macOS, sandbox disabled).
- Shared models in `core`: Organization, Project, ProjectLink, Task, TaskEvent, Artifact.
- Storage with drift: `registry.db` + per-org SQLite; repository layer that requires `orgId`.
- Models and API: organizations, projects, project links, tasks, task events, artifacts.
- Task status derived from events; reopen appends events.
- Flutter UI: org switcher, project picker, task list with filters (status, date range),
  task detail with full event timeline.
- Tests: repository layer, event sourcing, **org isolation**.

**Done when**: you can create orgs and projects, create and move tasks through the lifecycle
by hand, and browse any task's history by date.

## Phase 1: Health agent

- Project manifest format (YAML) and project onboarding flow (clone, detect, first build).
- FVM integration; deterministic pipeline; sequential build queue.
- Health Reports stored as artifacts; status shown per project in the UI.
- Claude Code CLI non-interactive introduced for failure diagnosis (structured JSON output, no
  tool access) and for trivial fixes on a branch.

**Done when**: one click checks all projects and failures come with a diagnosis.

## Phase 2: Chat and Orchestrator

- Conversations and channels (General + per-agent) per project and per org.
- WebSocket streaming of agent responses via Claude Code CLI (`--output-format stream-json`),
  continued per (role, project) with `--resume`; persisted in the org DB; token budgets;
  static context placed first for prompt caching.
- A small local MCP server exposes task-board actions (create/list/assign) so the Orchestrator
  can create and assign tasks from chat.

**Done when**: you can delegate a task in General and talk 1:1 with Health.

## Phase 3: Analyst and ingestion

- Ingestion workers: Slack, Google Chat, WhatsApp manual import.
- ERF import via MarkItDown/Docling.
- Message routing to org/project with confidence; low confidence asks the owner.
- Task Specs with requirement IDs and open questions.
- Morning briefing (all-organizations dashboard).

**Done when**: new work messages become reviewable Task Specs without manual copying.

## Phase 4: Creative

- Org design system package + Widgetbook referenced by projects.
- Design Specs and Mermaid user flows from Task Specs/ERFs, with requirement IDs.
- Screen code from design system components; screenshots via golden tests.
- Mermaid rendering in the UI.

**Done when**: "make a flow diagram of feature X from this ERF" works end to end.

## Phase 5: Developer and Reviewer

- Git worktree per task; Developer runs Claude Code non-interactively there, with the Dart and Flutter MCP server.
- PRs via GitHub with requirement IDs.
- Reviewer reports; approval gates in the UI.
- Librarian updates knowledge after completed tasks.

**Done when**: a Task Spec can go to an approved PR with you only at checkpoints.

## Phase 6: Polish and packaging

- Outlook (Microsoft Graph); meeting transcription (platform transcripts or whisper.cpp/MLX).
- `dart compile exe` server, launchd LaunchAgent, DMG, first-run wizard, Keychain secrets.
- Optional: move backend to an always-on Mac mini over Tailscale.
