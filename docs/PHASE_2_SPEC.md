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
- **MCP server package**: `package:dart_mcp` (`labs.dart.dev`, the official Dart Labs package --
  same foundation as the `dart mcp-server` Flutter tooling CLAUDE.md already references). Extend
  `MCPServer` with the `ToolsSupport` mixin; register tools in an `initialize()` override;
  `stdioChannel(input: stdin, output: stdout)` wires it to a subprocess's stdio.
- **MCP tools still need `--allowedTools`.** Confirmed live: even with `--mcp-config` +
  `--strict-mcp-config` scoping the Orchestrator to exactly one MCP server, every tool call was
  silently blocked in non-interactive `-p` mode -- MCP tools go through the CLI's normal
  permission system, and there's no human to approve a prompt there. Fixed by passing
  `--allowedTools mcp__task-board__create_task mcp__task-board__list_tasks
  mcp__task-board__assign_task` (the `mcp__<server>__<tool>` naming is the CLI's own permission-name
  format). Verified live end-to-end afterward: create_task, assign_task, and list_tasks all worked
  for real, including a second turn that correctly remembered the first turn's task id via
  `--resume` session continuity.
- **A new enum value needs a core codegen rebuild, not just the source edit.** Adding
  `TaskEventType.assigned` (needed for `assign_task`) without rerunning `build_runner` in
  `packages/core` left the generated json_serializable enum map missing that one entry --
  `TaskEvent.toJson()` compiled fine and every *existing* test still passed (none of them exercised
  the new value), but calling it live threw a null-check error. Caught live, fixed by rebuilding
  core's codegen; a new round-trip test now iterates every `TaskEventType` value specifically to
  catch this class of bug before it reaches a live run again.
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
- **Streaming transport** (confirmed live against the real CLI, v2.1.222): `--output-format
  stream-json` requires `--verbose` in print mode -- the CLI errors otherwise. Output is NDJSON;
  the visible reply text arrives as `{"type":"stream_event","event":{"type":
  "content_block_delta","delta":{"type":"text_delta","text":...}}}` lines, interleaved with
  `thinking_delta` lines (the model's hidden reasoning, not surfaced to the user) and bookkeeping
  lines (`system`, `rate_limit_event`, etc., all ignored). The same final `{"type":"result",
  "result":...}` line from the non-streamed path is still the authoritative last line and is what
  gets persisted -- deltas are display-only, never what's written to `chat_messages`.
- **`--tools ""` doesn't fully hide MCP context.** Verified live: a reply mentioned "only Claude
  Docs tools are enabled," meaning the CLI can still surface ambient MCP servers configured
  globally for the machine's Claude Code install, even with built-in tools disabled. Slice 4's
  task-board MCP bridge must pass `--strict-mcp-config` so only the one intended MCP server is
  ever visible to a turn, not whatever else happens to be configured on the developer's machine.
- **Hub design**: `ChatStreamHub` is in-memory, process-wide pub/sub keyed by conversation id,
  typed against the generic `StreamChannel` (from `package:stream_channel`) rather than
  `WebSocketChannel` specifically -- both the server's hub and the app's `ApiClient` return/accept
  the generic type for the same reason: `WebSocketChannel` in this package version has no public
  constructor from an arbitrary channel, so tests need the generic type to inject a purely
  in-memory fake instead of a real socket.

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
- [x] 3. WebSocket streaming
- [x] 4. Orchestrator General channel + MCP task-board bridge + remaining roles
