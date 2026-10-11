# Phase 6 Spec

Polish and packaging: a generic connector framework for message/transcript sources (Outlook
first, meeting transcripts second), and turning the already-complete Phases 0-5 into a real
installed app.

## Decisions

- **A generic connector framework, not bespoke per-service integrations.** Originally scoped as
  "Outlook (Microsoft Graph); meeting transcription" as two one-off pieces of work. Instead:
  Agentic ships a small, growing built-in registry of `core.ConnectorDefinition`s (id,
  displayName, OAuth authorize/token URLs, scopes) plus one small `ConnectorAdapter` class per
  service that fetches and normalizes that service's messages/transcripts into `core.Message`.
  The OAuth handshake (authorize redirect, code exchange, token refresh, credential storage) is
  fully generic and shared across every connector; only the adapter's fetch-and-map logic is
  service-specific. Adding a new service later (Gmail, Discord, Teams, ...) means writing one
  definition + one adapter, not a new ingestion subsystem, route set, and auth flow each time.
- **Outlook is the framework's first real connector; meeting transcripts become a second
  connector (platform transcripts via Zoom/Teams/Meet APIs), not a separate local-recording
  subsystem.** Both are OAuth-backed APIs, so both fit the same framework. Local recording +
  whisper.cpp/MLX Whisper (no OAuth, needs Screen Recording/Mic permissions, a new external-CLI
  dependency) is explicitly deferred -- out of scope for this phase, worth its own look later if
  a meeting platform's transcript API proves insufficient.
- **`SourceKind.meeting` is retired in favor of `SourceKind.oauthConnector`** (new value;
  `slack`/`gchat`/`outlook` -- never implemented, confirmed by grep -- are retired too). A
  connector-backed `Source.config` carries `{"connectorId": "outlook"}` (or `"zoom"`, etc.)
  pointing at the registry entry; `whatsappImport` and `erf` are untouched since they aren't
  OAuth-shaped. Safe to remove the unused values now since nothing branches on them yet.
- **OAuth client id/secret are owner-supplied per (org, connectorId), not baked into Agentic.**
  This is a personal tool, not a published multi-tenant app -- the owner registers their own
  Azure AD / Zoom app per connector they want to use (often per-tenant anyway, e.g. an employer's
  M365 tenant) and pastes the client id/secret in during the connect flow. Stored in Keychain
  (`agentic.<orgId>.connector.<connectorId>.clientSecret`), never the DB, per the project's
  existing secrets rule. Access/refresh tokens are stored the same way, in the same place.
- **The OAuth redirect URI is fixed** (`http://127.0.0.1:8787/connectors/callback`), not
  per-org/per-connector -- the one thing most OAuth providers require to be pre-registered
  exactly. `orgId` + `connectorId` + a CSRF nonce travel in the `state` parameter instead (the
  standard pattern for carrying context through a redirect-based OAuth flow), verified against a
  short-lived server-side record on callback.
- **Connector message-fetching is a manually-triggered "Sync" action, not a new cron scheduler.**
  `ARCHITECTURE.md` describes a `cron`-based Scheduler component, but nothing has actually built
  it yet -- ERF scan and WhatsApp import are both manually triggered via a `POST .../scan`-style
  route today, same as Health checks. Connector sync follows that same existing precedent
  (`POST .../sources/<sourceId>/sync`) rather than introducing real background scheduling as a
  side effect of this phase; worth a dedicated look later alongside Health's own cron gap.
- **Packaging (compiled server, launchd LaunchAgent, DMG, first-run checks) comes last**, once
  the connector framework and its first two connectors are settled, so packaging work doesn't
  need redoing as new config/permissions get added mid-phase.

- **`ConnectorSyncService` mirrors `WhatsAppImportService`'s pipeline exactly** (dedup by
  `externalId` via `getOrCreateMessage`, route only new messages, extract a Task Spec from
  whatever ends up routed) rather than inventing a new ingestion shape -- the only connector-
  specific step is the adapter's `fetchSince` call; everything after that is the same generic
  message pipeline every source in this codebase already shares.
- **No new `lastSyncedAt` field -- the sync cursor is derived from the latest existing message's
  `sentAt`**, the same "derive state from what's already stored" approach `nextVersion` already
  uses for artifacts, rather than adding stored sync-cursor state that could drift from reality.
  `externalId` dedup is still the actual correctness guarantee; the cursor is purely an efficiency
  optimization so a resync doesn't re-fetch an entire mailbox.

- **Slice 3 needed zero new routes, zero new `AppContext`/sync-service changes** -- just a
  `ConnectorDefinition`, a `ZoomAdapter`, and two lines registering both in
  `ConnectorRegistry`. `POST .../sources/<sourceId>/sync` already worked for any
  `oauthConnector` source regardless of `connectorId`, since slice 1/2 built that generically.
  This is the framework paying off exactly as intended.
- **`ZoomAdapter` is a two-step fetch**: list recordings (`/users/me/recordings`, `from`/`to` +
  `next_page_token` pagination), then download the `TRANSCRIPT`-type recording file's VTT content
  for each meeting that has one. A meeting with no transcript (not cloud-recorded, or
  transcription wasn't enabled) is silently skipped, not an error -- most meetings won't have one.
- **`ConnectorMessage.author` is left unset for transcripts.** Unlike a mail message, a meeting
  transcript has no single sender -- forcing one would misrepresent a multi-party conversation.

- **`ConnectionsScreen` ships Connect + Sync; Disconnect is deferred.** The build-order text
  below originally said "Disconnect" too, but no backend route for revoking a connection (deleting
  the Source row, clearing its Keychain entries) was ever built in slices 1-3. Rather than bolt
  one on unplanned, this slice stays to what's actually backed by a real route; worth a small
  dedicated follow-up later.
- **The screen has no "finish connecting" step of its own.** `beginConnectorConnect` returns the
  authorize URL, the app opens it in the system browser via `url_launcher`, and the `Source` gets
  created server-side once the OAuth callback lands (already built in slice 1) -- the owner just
  comes back and taps the refresh icon. No polling, no deep link back into the app.
- **Found and fixed live: the new "Connections" tab pushed "Dashboard" off the visible tab bar**,
  breaking `app_shell_test.dart`'s existing tap-to-navigate test (the horizontal
  `SingleChildScrollView` doesn't auto-scroll a tapped widget into view) -- a genuine usability
  regression on a narrow window, not just a test artifact. Fixed by appending "Connections" after
  "Dashboard" instead of before it, so every existing tab keeps its prior on-screen position.

- **Found live: `dart compile exe` doesn't support packages with native build hooks, and
  `sqlite3` (used by `drift`) has one** -- the `ARCHITECTURE.md`/`CLAUDE.md` text calling for
  `dart compile exe` was simply wrong, caught only by actually trying to compile. The fix is
  `dart build cli`, the newer command that does support build/link hooks: it produces a
  `bundle/` directory (`bin/server` + `lib/libsqlite3.dylib`) rather than one standalone file --
  the two must be installed and shipped together, since the binary loads the dylib via a path
  relative to its own location. `scripts/install_launchagent.sh` copies the whole bundle, not
  just the binary.
- **No first-run wizard screen -- the external-dependency check was folded into the existing
  empty-dashboard state instead.** `ARCHITECTURE.md`'s original "First-run wizard: Claude API
  key, org creation, OAuth connections, repo folders" bullet was stale on its own terms: no
  separate Claude API key is ever collected (every agent reuses the Claude Code CLI's own auth,
  per §6, true since Phase 0), and org creation/project creation/OAuth connections already have
  real UI (`OrgSwitcher`'s "+", project creation, the new Connections screen) -- there was nothing
  left to build a dedicated wizard flow around except the dependency check itself, which now
  replaces the plain "No organizations yet" message on first launch.
- **Live-verified for real**: `scripts/build_server.sh` produced a working arm64 binary that,
  run standalone, correctly served `/health`, `/system/check` (real git/flutter/claude versions),
  and `/orgs` (reading the real SQLite registry through the bundled native library) --
  confirming the native-asset bundling actually works, not just that it compiles.
  `scripts/build_dmg.sh` produced a DMG that mounts and contains a working `Agentic.app`.
  `scripts/install_launchagent.sh` was reviewed but not actually run against the real
  `~/Library/LaunchAgents` -- registering a LaunchAgent is a persistent, auto-starting system
  change, left for the owner to trigger deliberately rather than as a side effect of this slice.

## Build order

1. Connector framework core: `core.ConnectorDefinition`, `ConnectorAdapter` interface, a static
   `ConnectorRegistry`. Generic OAuth routes (`/connectors` list, `/orgs/<orgId>/connectors/
   <connectorId>/connect` to start the flow, `/connectors/callback` to finish it), Keychain
   credential storage (client id/secret, access/refresh tokens, with refresh-on-expiry), a
   `Source` row created on successful connect. No real adapters yet -- tested with a fake
   in-memory OAuth provider.
2. Outlook adapter: Microsoft Graph `/me/mailFolders/Inbox/messages` with an incremental
   `receivedDateTime` filter, mapped into `core.Message`. `POST .../sources/<sourceId>/sync`
   feeds the existing Analyst routing pipeline -- no changes needed downstream of `Message`.
3. A meeting-transcript connector (Zoom to start): same framework, adapter fetches recent
   meeting transcripts and maps each to one `core.Message` (the full transcript as `body`).
4. UI: a "Connections" screen per org -- lists available connector types from the registry,
   "Connect" opens the system browser for the OAuth flow, shows connected accounts with a
   "Sync now" action (Disconnect deferred -- no backend route for it yet).
5. Packaging: a compiled server binary via `dart build cli` (`scripts/build_server.sh`), a
   launchd LaunchAgent plist + install/uninstall scripts, a DMG for the Flutter app (unsigned,
   per `ARCHITECTURE.md` -- fine for personal use, `scripts/build_dmg.sh`), and an external
   dependency check (`GET /system/check`) surfaced as part of the first-run (no orgs yet) state.

**Done when**: the app is a real installed thing you launch normally (not `dart run`/
`flutter run`), and at least one real connector (Outlook) can bring in new messages without
manual file copying.

## Progress

(Update after each approved slice.)

- [x] 1. Connector framework core (OAuth routes, Keychain storage, registry)
- [x] 2. Outlook connector adapter
- [x] 3. Meeting-transcript connector adapter (Zoom)
- [x] 4. Connections UI
- [x] 5. Packaging (compiled server, launchd, DMG, first-run dependency check)
