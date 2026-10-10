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
- **Packaging (`dart compile exe`, launchd LaunchAgent, DMG, first-run wizard) comes last**, once
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
   "Sync now" and "Disconnect" action.
5. Packaging: `dart compile exe` for the server, a launchd LaunchAgent plist, a DMG for the
   Flutter app (unsigned, per `ARCHITECTURE.md` -- fine for personal use), a first-run wizard
   (external dependency checks, Claude Code auth, first org, first connector connection).

**Done when**: the app is a real installed thing you launch normally (not `dart run`/
`flutter run`), and at least one real connector (Outlook) can bring in new messages without
manual file copying.

## Progress

(Update after each approved slice.)

- [x] 1. Connector framework core (OAuth routes, Keychain storage, registry)
- [x] 2. Outlook connector adapter
- [ ] 3. Meeting-transcript connector adapter (Zoom)
- [ ] 4. Connections UI
- [ ] 5. Packaging (compile exe, launchd, DMG, first-run wizard)
