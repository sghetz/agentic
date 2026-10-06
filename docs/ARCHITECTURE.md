# Architecture

## 1. Purpose

Mimic an isolated software team for one developer. Agents handle daily work: analyzing
instructions from chat, email, and calls; checking that projects build and run; designing
screen flows from functional requirement documents (ERFs); implementing; and reviewing.
The owner can pick any project, consult or delegate to any agent, and review any task's
history at any date.

## 2. Hierarchy and scoping

```
Organization  ->  Project  ->  Task
```

**Organization**: a hard context boundary (e.g. "Employer", "Personal", later a client).
Owns: integrations/credentials, design system reference, conventions, policies, contacts.

**Project**: belongs to exactly one organization. Owns: repos, ERFs, Flutter version (via FVM),
project conventions, agent memory. Inherits organization context and may override it.

**Task**: belongs to exactly one project. Event-sourced history plus linked artifacts.

### Scope levels in the UI

| Scope | Use | Data access |
|---|---|---|
| Project | Most work: chat, delegate, review | That project + its org context + linked projects in same org |
| Organization | Cross-project questions within one org | All projects in that org |
| All organizations | Morning dashboard | Read-only summaries, assembled per org DB |

Every chat message and agent invocation carries an explicit scope `(org_id, project_id?)`.

### Project links

Typed relations: `depends_on`, `shares_code_with`, `related`.
Within one org, linked projects may share context (e.g. Developer reads the API of a package
the app depends on). Across orgs: metadata-only links, no context sharing.

## 3. Data isolation

- `registry.db`: list of organizations, global settings. No project content.
- `orgs/<org_id>/data.db`: everything for one organization.
- Location: `~/Library/Application Support/Agentic/`.
- Repos on disk: `~/Agentic/repos/<org_slug>/<project_slug>/`.
- Credentials: Keychain entries namespaced per org.
- Deleting an organization = deleting its folder and Keychain entries.

The repository layer opens the DB by `org_id`. There is no API that accepts two org IDs.
Tests must prove an agent in org A cannot retrieve any record from org B.

## 4. Data model (per-org DB)

```
projects        id, name, slug, repos(json), flutter_version, design_system_ref,
                status, created_at, archived_at
project_links   from_project_id, to_project_id, relation
sources         id, kind (slack|gchat|outlook|whatsapp_import|meeting|erf), config(json),
                project_id (nullable = org-level, needs routing)
messages        id, source_id, external_id, author, sent_at, body, raw(json),
                routed_project_id, routing_confidence, processed_at
tasks           id, project_id, title, current_status, source_message_id, created_at
task_events     id, task_id, ts, actor (user|agent:<role>), event_type, payload(json)
artifacts       id, task_id, kind (task_spec|design_spec|diagram|health_report|pr|review),
                uri, version, created_at
conversations   id, project_id (nullable for org scope), channel (general|<role>),
                agent_session_id
chat_messages   id, conversation_id, ts, sender, content
knowledge       id, project_id (nullable = org-level), kind, title, content, embedding
```

### Task lifecycle

```
new -> specified -> in_design -> in_development -> in_review -> awaiting_approval -> done
```
`blocked` and `reopened` can occur from any state. Reopening appends events; history is never
rewritten. Text artifacts (specs, Mermaid diagrams) are versioned so any past state can be shown.

## 5. Components

```
Flutter macOS app (packages/app)
   |  HTTP + WebSocket (localhost; designed to work over network later)
   |  shared models from packages/core
Dart server (packages/server; compiled exe, launchd LaunchAgent, runs at login)
   |-- API layer (shelf): orgs, projects, tasks, events, artifacts, chat
   |-- Agent runtime: dartantic_ai + Anthropic provider; one conversation per (role, project)
   |-- Coding runner: Claude Code non-interactive subprocess in a git worktree per task
   |-- Ingestion workers: pull sources on schedule into `messages`
   |-- Health runner: deterministic build/lint/test pipeline per project (Process.run + FVM)
   |-- Scheduler: `cron` package (ingestion, health checks, morning briefing)
   |-- Storage: drift; registry.db + per-org SQLite (+ vector extension for knowledge)
```

### Why this split

- One language (Dart) end to end; models shared between UI and server via `packages/core`.
- `dartantic_ai` provides the agent loop, typed tool calling, embeddings, and MCP support.
- Coding work is delegated to Claude Code rather than rebuilt, because reliable file editing,
  shell execution, and context management are its core strengths.
- Python-only tools (MarkItDown, Whisper) are external CLIs, not part of the codebase.

The backend runs independently of the UI. The UI is a client. Moving the backend to an
always-on Mac mini later should be a configuration change.

## 6. Agents

See `docs/AGENTS.md` for full role specs. Summary:

| Agent | Produces |
|---|---|
| Orchestrator | Routing decisions, task creation, briefings |
| Analyst | Task Specs (with requirement IDs and open questions), message routing |
| Health | Health Reports; trivial fixes |
| Creative | Design Specs, user/screen flow diagrams (Mermaid), screen code using the org design system |
| Developer | Branches, code, PRs |
| Reviewer | Review Reports (acceptance criteria + code quality + RF coverage) |
| Librarian | Project knowledge docs; onboarding audit summaries |

Coordination is through the task board (tasks, events, artifacts), not agent-to-agent chat.
Most reasoning agents run on dartantic_ai. Health diagnosis and Developer (and Health fixes)
instead delegate to Claude Code in non-interactive mode (`-p`, `--json-schema` for structured
output, `--tools ""` to disable tool access for diagnosis-only calls): this reuses whatever
Claude Code auth is already on the machine instead of a second metered API key, and Developer
work needs the git worktree and file/shell tools anyway.
Each agent's context = role prompt + org context + project context + task artifacts.
Static context (design system, conventions) is placed first in prompts to maximize caching.

## 7. Integrations

| Source | Approach | Notes |
|---|---|---|
| Slack | Web API, user token | Read channels the user is in |
| Google Chat | Chat API, user auth | Spaces the user belongs to |
| Outlook | Microsoft Graph | Later phase |
| WhatsApp | Manual export/forward import (v1) | Unofficial clients risk account bans; Cloud API has no groups |
| Video calls | Platform transcripts, or local recording + whisper.cpp / MLX Whisper | Needs Screen Recording + Mic permissions; ScreenCaptureKit for system audio |
| ERF documents | MarkItDown or Docling -> markdown | Analyst extracts numbered requirements |
| GitHub | GitHub MCP server / API | Separate token per org |
| Flutter | `dart mcp-server`, FVM | One MCP instance per project root |

## 8. Design system

One design system per organization, kept as a standalone Flutter package (theme, tokens,
base components) with a Widgetbook catalog. Projects import it. The Creative agent loads it
as fixed context and may only build screens from its components and tokens.

## 9. Adding a project

1. Choose organization; point to a GitHub repo (or create one).
2. Health agent clones, detects Flutter version, state management, structure, deps; first build.
3. Librarian drafts a project knowledge doc for the owner to review.
4. Owner maps sources (channels, spaces, ERF folders) to the project.
5. Result saved as a project manifest (`manifests/` shows the format) and in the org DB.

Finished projects are archived, never deleted.

## 10. Packaging (macOS)

- UI: Flutter macOS app, sandbox disabled, DMG. Unsigned is fine for personal use.
- Server: `dart compile exe` single binary, registered as a launchd LaunchAgent.
- External dependencies checked on first run: git, Flutter/FVM, Claude Code, and (later) MarkItDown, whisper.cpp.
- First-run wizard: Claude API key, org creation, OAuth connections, repo folders.

## 11. Open decisions

- MacBook vs desktop Mac (affects scheduling around sleep).
- Employer policy on sending code/requirements to an external API: confirm before using
  employer data.
- Vector extension choice for SQLite (e.g. sqlite-vec loaded through drift/sqlite3).
- Flutter state management for the app (owner preference).
