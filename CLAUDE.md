# Agentic

A personal, installable macOS app that gives one developer (a Flutter developer) an isolated
"software team" of AI agents. Each agent has a distinct role; all share scoped project context.
The owner talks to agents one-on-one or in a general chat, per project.

Agentic is the project name; use it for the app name, bundle display name, and data folders.

Full design: `docs/ARCHITECTURE.md`. Build plan: `docs/ROADMAP.md`. Agent roles: `docs/AGENTS.md`.
Current phase spec: `docs/PHASE_2_SPEC.md` (follow it exactly; update its Progress list after each approved slice).
Always check the roadmap for the current phase before starting work, and do not build ahead of it.

## Stack (all Dart)

- **Monorepo**: Dart pub workspace with three packages (see layout).
- **Shared models** (`packages/core`): data models and artifact types used by both server and app.
- **Backend** (`packages/server`): Dart, `shelf` + `shelf_router`, WebSockets, `drift` (SQLite),
  `cron` for scheduling. Compiled with `dart compile exe`.
- **Agents**: every reasoning and conversational agent (Orchestrator, Analyst, Health, Creative,
  Reviewer, Librarian) runs on Claude Code CLI non-interactively -- reuses existing Claude Code
  auth, no separate Anthropic API key. One conversation per (role, project), continued across
  turns with `--resume`/`-c`; structured output via `--json-schema`; tool-free calls (e.g. Health
  diagnosis) via `--tools ""`. An agent that needs to take an action during a conversation (e.g.
  Orchestrator creating a task) gets a narrow local MCP server exposing just that action, wired
  in via `--mcp-config`.
- **Coding work**: the Developer agent (and Health fixes) run **Claude Code in non-interactive
  mode as a subprocess** inside a dedicated git worktree, and the server collects its output.
  Do not hand-write file-editing or shell tools for coding tasks.
- **UI** (`packages/app`): Flutter macOS desktop. App Sandbox disabled (needs git, flutter, repos).
- **Flutter tooling**: Dart and Flutter MCP server (`dart mcp-server`), FVM for per-project SDKs.
- **External CLIs** (called via `Process.run`, later phases): MarkItDown for ERFs, whisper.cpp for transcription.
- **Secrets**: macOS Keychain. The app uses `flutter_secure_storage`; the server uses the
  `security` CLI. Never write tokens or API keys to files, logs, or the DB.

## Repo layout

```
pubspec.yaml            workspace root
packages/core/          shared models (Dart only, no Flutter imports)
packages/server/        backend: API, storage, agents, ingestion, health runner
packages/app/           Flutter macOS UI
docs/                   architecture, roadmap, agent role specs
manifests/              example project manifests (YAML)
```

`core` must never depend on Flutter or on server-only packages, so both sides can import it.

## Non-negotiable rules

1. **Organization isolation is enforced in code, not prompts.** Every data access goes through a
   repository layer that requires an `orgId`. Each organization has its own SQLite file.
   No query, retrieval, or agent context may ever combine data from two organizations.
   The only cross-org view is the read-only dashboard, which reads summaries from each DB separately.
2. **Tasks are event-sourced.** Never update task history in place. Every change appends a row to
   `task_events`. `tasks.currentStatus` is a derived/cached value.
3. **Agents never act irreversibly without approval.** No pushing to main, merging PRs, sending
   messages/emails, or deleting data without an explicit human approval event.
4. **Deterministic first.** Builds, lint, tests, git operations, and ingestion are plain code.
   Invoke the LLM only for judgment (diagnosis, analysis, design, code writing, review).
5. **Structured handoffs.** Agents exchange typed artifacts (Task Spec, Health Report, Design Spec,
   PR, Review Report) defined as models in `core`, not free-form prose.
6. **Traceability.** Requirement IDs from ERFs (e.g. RF-07) flow through specs, diagrams, code, and PRs.

## Conventions

- Dart 3 with sound null safety; models are immutable with JSON serialization.
- `dart analyze` clean with recommended lints; `dart format` on every change.
- Tests with `package:test` (core, server) and `flutter_test` (app).
- Diagrams produced by agents are Mermaid text, stored as versioned artifacts.
- Write tests for the repository layer and org isolation before features that use them.
- UI state management: (owner to specify in the first session).

## Commands

(Update as they are created.)

```
dart pub get                                  # from workspace root (core + server only)
dart run packages/server/bin/server.dart      # run backend
dart test packages/core packages/server       # backend tests
cd packages/app && flutter pub get            # app deps (resolved independently, see note below)
cd packages/app && flutter run -d macos       # run UI
cd packages/app && flutter test               # UI widget tests
```

`packages/app` is intentionally **not** a member of the root Dart pub workspace: Flutter's
bundled `flutter_test` pins `test_api`/`matcher` to exact internal versions that don't line up
with any published `test` release, which makes one unified workspace lockfile across the app
and core/server's codegen tooling (`freezed`, `drift_dev`) unsatisfiable. `packages/app` depends
on `core` via a plain relative path dependency and resolves independently with its own
`pubspec.lock`.
