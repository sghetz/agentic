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
- **Session continuity**: each `conversations` row gets a server-generated UUID stored as
  `claude_session_id`, passed as `--session-id <uuid>` on every turn for that conversation (first
  turn creates it, later turns resume it). Confirmed empirically in slice 2 before building on top
  of it -- if `--session-id` doesn't behave as expected on the installed CLI version, fall back to
  parsing the `session_id` the CLI's own JSON result emits and resuming with `--resume`.
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
- [ ] 2. Health conversation over Claude Code CLI (non-streamed)
- [ ] 3. WebSocket streaming
- [ ] 4. Orchestrator General channel + MCP task-board bridge + remaining roles
