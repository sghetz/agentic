# Phase 2 Spec

Chat and Orchestrator: conversations/channels per project and org, Claude Code CLI driving every
agent's side of the conversation (replacing the originally-planned dartantic_ai -- see decision
below), WebSocket streaming, and a small MCP bridge so the Orchestrator can create/assign tasks
from chat.

## Decisions

- **Claude Code CLI replaces dartantic_ai for every agent, not just Health.** Phase 2's defining
  feature -- the Orchestrator creating a task mid-conversation -- needs typed tool calling, which
  dartantic_ai would provide natively but only in exchange for a second, metered Anthropic API key
  on top of the existing Claude Code subscription. Since that subscription is rarely maxed out in
  practice, every agent's conversation instead runs as a Claude Code CLI subprocess, with a small
  local MCP server exposing the handful of actions a role needs to perform (just task-board writes
  for the Orchestrator, for now). Worst case if the subscription limit is ever hit is throttling,
  not a surprise bill. `core`/server docs updated accordingly; `dartantic_ai` is no longer a planned
  dependency anywhere in the project.
- **Session continuity** (confirmed empirically against the real CLI, v2.1.222): each
  `conversations` row gets a server-generated UUID stored as `claude_session_id`. The *first* turn
  passes `--session-id <uuid>`, which creates a new session under that id. Every *later* turn
  passes `-r/--resume <uuid>` instead -- `--session-id` on an id that already exists is a hard
  error ("Session ID ... is already in use"), it does not resume. Verified a real two-turn exchange
  this way: turn 2 correctly recalled a fact stated only in turn 1, and `cache_read_input_tokens`
  on turn 2 showed the CLI reusing turn 1's cached prompt, not resending it.
- **No manual transcript/token-budget bookkeeping.** Claude Code's own session persistence holds
  prior turns; we only ever send the latest user message as the `-p` prompt, not the full history.
  "Token budget" in this phase means: cap how much static role/project context (conventions,
  project knowledge once it exists) is injected, and confirm in slice 2 whether that context needs
  resending every turn or only once at session creation.
- **Channel scoping**: `general` exists at both org scope (`project_id` null) and each project's
  scope; per-agent channels (`agent:<role>`) are project-scoped only, since every role but the
  Orchestrator works against a specific project's repo/context. Matches the `conversations` /
  `chat_messages` schema already in `ARCHITECTURE.md` section 4.
- **Streaming is additive, not required for correctness.** The full assistant reply is always
  persisted to `chat_messages` once the CLI subprocess exits, regardless of whether a WebSocket is
  open. The socket only improves the live UX; a client that reconnects just re-fetches messages
  over HTTP.
- **MCP bridge is scoped to one org (and project, when project-scoped) per invocation.** The MCP
  server is spawned per Claude Code CLI call with the relevant org/project IDs passed in explicitly
  (args or env), so it can only ever reach that one org's database -- preserves the org-isolation
  rule the same way every other service does.
- **MCP server package**: pick an MCP SDK from pub.dev when slice 4 starts (prefer an official/
  actively maintained one); not pinned yet since it isn't needed until then.
- **`workingDirectory` matters beyond file access.** Claude Code auto-includes cwd/git-status/
  CLAUDE.md context in its system prompt by default, even with `--tools ""`. A chat turn must run
  with `workingDirectory` set to the *target* project's own cloned repo, never the Agentic server's
  own source tree -- confirmed live: without this, a reply would reflect Agentic's own dev state
  (e.g. "I see you're working on Phase 2") instead of the project being discussed.
- **The subprocess needs the real Claude Code auth on disk.** Verified live: running the server
  with `HOME` overridden to a scratch directory (as used for isolated test runs) makes every chat
  reply silently fail-closed (best-effort -> null), because the `claude` subprocess it spawns can't
  find credentials under that `HOME`. Same root cause as the git-credentials issue from Phase 1,
  now for Claude Code's own auth. Live verification of this feature specifically needs the real
  `$HOME`.
- **Known cosmetic quirk**: with `--tools ""`, the model sometimes still narrates a hypothetical
  tool call in its reply text (e.g. "I'll check the project structure... **1 tool use**") even
  though nothing actually ran and the final answer is correct. Not fixed in this slice; worth a
  prompt tweak later if it's distracting in the UI.

## Build order

1. Conversations/chat_messages data model + HTTP CRUD (list channels per scope, list messages,
   post a user message) with no agent reply yet -- deterministic, same testing style as Phase 0.
   Flutter: channel list (General + per-role) per project and org, basic chat view.
2. Wire Health's conversation to a real Claude Code CLI subprocess per turn (`-p`, `--session-id`,
   `--output-format json`, non-streamed: wait for the full reply, store it, return it over HTTP).
   This is where `--session-id`/`--resume` and system-prompt behavior get confirmed against the
   real CLI before anything else depends on it.
3. WebSocket streaming: add `shelf_web_socket`, switch to `--output-format stream-json`, stream
   incremental deltas into the UI for Health's conversation.
4. Orchestrator's General channel + the MCP task-board bridge (`create_task`, `list_tasks`,
   `assign_task`), then wire the remaining roles (Analyst, Creative, Developer, Reviewer,
   Librarian) onto the same mechanism now that it's proven.

**Done when** (from ROADMAP.md): you can delegate a task in General and talk 1:1 with Health.

## Progress

(Update after each approved slice.)

- [x] 1. Conversations/chat_messages data model + HTTP CRUD + basic chat UI
- [x] 2. Health conversation over Claude Code CLI (non-streamed)
- [ ] 3. WebSocket streaming
- [ ] 4. Orchestrator General channel + MCP task-board bridge + remaining roles
