# Phase 5 Spec

Developer and Reviewer: turn a Task Spec (and Design Spec, when UI is involved) into an
approved, merged PR, with the owner only at checkpoints.

## Decisions

- **PR creation is a deterministic server step via the `gh` CLI, not a GitHub MCP server or a
  tool the agent calls itself.** Extends the exact pattern `git_service.dart`/
  `trivial_fix_service.dart` already established in Phase 1: Claude Code's non-interactive
  session gets `Edit` + `Bash(flutter *) Bash(dart *) Bash(fvm *)` only -- no `git` or `gh` tool
  at all. After it finishes, the server independently re-runs the Health pipeline to verify the
  branch actually builds, then (and only then) commits, pushes, and runs `gh pr create` itself.
  `gh` is already installed and authenticated on this machine; no new MCP server/token/infra.
- **The server merges via `gh pr merge`, triggered by one explicit in-app approval event.** The
  owner's "Approve" click in the UI *is* the explicit human approval event rule 3 requires; the
  server then runs `gh pr merge` deterministically. GitHub branch protection still enforces
  Codacy/Checkmarx/Jenkins/build checks and simply rejects the merge if they haven't passed --
  Agentic doesn't reimplement that gating, it just surfaces the result (see next point). This
  keeps the owner entirely inside Agentic; they never have to flip to github.com to finish a task.
- **The in-app approval screen polls and shows the external pipeline's check status** (Codacy,
  Checkmarx, Jenkins, build -- whatever's wired into the repo's branch protection) via
  `gh pr checks` next to the Reviewer's own Review Report, fetched live on demand (a manual
  refresh, not a background poller/WebSocket -- consistent with how little infra the rest of this
  app uses for "check status"). This is deliberately *not* persisted as an artifact: it's external,
  mutable state, not something Agentic produced, so it's always fetched fresh rather than risking
  a stale cached verdict.
- **Reviewer runs as a second Claude Code session in the same worktree, with the same tool
  access as Developer** (`Edit` + `Bash(flutter *) Bash(dart *) Bash(fvm *)`, no `git`/`gh`), so
  it can actually read the diff, re-run the pipeline, and add missing tests per `AGENTS.md`. Its
  own pipeline run is a fast local sanity check, not a substitute for Codacy/Checkmarx/Jenkins --
  Reviewer's distinctive value is acceptance-criteria and requirement-coverage judgment against
  the Task Spec, which only an LLM reading the diff + spec can do. Ends with a structured
  `--json-schema` Review Report (`core.ReviewReport`), same one-shot pattern as every other
  extraction service in this codebase. If Reviewer changes anything (e.g. adds a test), the
  server commits and pushes that too -- Reviewer never touches `git`/`gh` itself either.
- **The worktree is keyed by task id, not a disposable timestamp, and stays alive from Develop
  through Review until the PR is merged or the task is explicitly discarded.** Phase 1's
  `TrivialFixService` discards its worktree immediately after one attempt; here Reviewer needs
  the *same* checkout Developer just produced, so `AgenticPaths.worktreePath(orgSlug,
  projectSlug, taskId)` and branch `agentic/task-<taskId>` are reused across both steps.
  Removed only after a successful merge (or if the owner discards the task).
- **Develop and Review are two separate, owner-triggered actions, not one chained call.** Unlike
  Design Spec's single generate() call (one deterministic extraction producing two artifacts
  atomically), Developer and Reviewer are independent agents per `AGENTS.md` ("Reviewer never
  reviews its own work") doing heterogeneous, multi-minute work. Two explicit actions give the
  owner a natural look at the diff/PR before Review runs, and match the task lifecycle's distinct
  `inDevelopment` / `inReview` states with a real transition between them instead of collapsing
  both into one opaque click.
- **Both long-running steps (`develop`, `review`) are plain synchronous HTTP calls with a
  generous timeout**, the same pattern already used for Health's clone+build+pipeline and
  Creative's generation call -- no new job queue/WebSocket-progress infrastructure. The UI shows
  a loading state while waiting, same as the existing Design Spec "Generate..." button.
- **Task-scoped artifacts (`pr`/`review`) gained a `content` field.** `CreateArtifactRequest`/
  `OrgStore.createArtifact` only ever supported `uri` before this slice -- fine when nothing
  produced a `pr`/`review` artifact yet, but `ReviewReport` has no natural `uri` and
  `PullRequestInfo` carries more than its own `url`. Mirrors the field project-scoped artifacts
  (`createProjectArtifact`) already had.
- **The develop route reuses the existing `statusChanged`/`InvalidTaskTransition` machinery
  instead of a bespoke guard.** It only appends a `-> inDevelopment` event when the task isn't
  already there (so a retry after `verificationFailed` doesn't re-append a same-state
  transition); any other starting status that can't reach `inDevelopment` (new, inReview,
  done, ...) falls through to the task state machine's own check and comes back as the existing
  409 + allowed-transitions shape, with no new error path to maintain.
- **`mergePr` never passes `gh`'s `--delete-branch` flag.** At the point approval happens, the
  branch is still checked out in the task's worktree, and `git branch -D` refuses to delete a
  branch checked out in *any* worktree, not just the one `gh` runs from -- passing it would make
  every merge fail. The local branch is deleted deterministically instead, via `removeWorktree`,
  after a successful merge; the remote branch is left for the repo's own merge-cleanup settings
  (or manual cleanup) to handle.
- **Reviewer never runs `git diff` itself -- the diff is computed deterministically beforehand
  and inlined into its prompt.** Reviewer's tool access is otherwise identical to Developer's
  (`Edit` + `flutter`/`dart`/`fvm` bash, no `git`/`gh`), and a read-only `git diff`/`log` carve-out
  would be one more allowlist pattern to get exactly right for no real benefit over just computing
  the diff server-side and handing it over as text.
- **`POST .../review` takes no body -- it re-finds whatever Task Spec (and Design Spec, if any)
  `develop()` used**, via the `artifactAttached` events `develop()` already records, rather than
  asking the owner to re-pick the same artifact a second time. `develop()` itself still requires
  an explicit `taskSpecArtifactId`, since nothing is attached yet at that point.
- **`core.ReviewReport`** (per `AGENTS.md`): acceptance criteria met/unmet, requirement coverage
  (which requirement IDs from the Task Spec are addressed), code quality issues, and missing
  tests noted (whether or not Reviewer wrote any itself). Stored as the task-scoped `review`
  artifact; the PR's own metadata (number, URL, branch) stored as the task-scoped `pr` artifact.
- **Slice 4 was verified against a real GitHub repo and the real `gh` binary, not just the test
  suite's faked one.** Every automated test in this phase fakes `gh`'s process output, so nothing
  had actually proven `GitHubService`'s assumptions about `gh`'s real CLI contract (createPr's
  URL-parsing, getChecks' `statusCheckRollup` shape, mergePr's exit behavior) held up. A throwaway
  private repo (seeded with a real `flutter create` scaffold, since the Health pipeline needs a
  genuinely buildable project to pass) was pushed through the full real flow -- real Task Spec
  extraction, real Developer session, real `gh pr create`, real Reviewer session, real
  `gh pr view --json statusCheckRollup`, real `gh pr merge` -- confirming all of it against the
  actual binary, with the real PR genuinely merging on GitHub. Deleted afterward (repo deletion
  needs the `delete_repo` gh scope, which this machine's token doesn't have -- left for the owner
  to grant or delete manually).
- **Found and fixed live: `DevelopmentPanel`'s content was unbounded and overflowed the task
  detail screen's layout** once it had real content (a PR link plus a multi-line Review summary)
  -- it squeezed the Activity/Artifacts row below it past usable height, a genuine `RenderFlex`
  overflow, not a sandbox artifact. Fixed by wrapping it in a height-capped `SingleChildScrollView`
  in `task_detail_screen.dart`.

## Build order

1. `GitHubService`: deterministic `gh` CLI wrapper (push + `gh pr create`, `gh pr checks`,
   `gh pr merge`) + `core.ReviewReport` model. Pure plumbing, no LLM, tests mock the process
   invoker the same way `GitService`'s tests do.
2. `DeveloperService`: task-keyed worktree, non-interactive Claude Code session (Task Spec +
   optional Design Spec as context, `Edit`/`Bash` tools only), Health-pipeline verification,
   commit + push + PR creation via `GitHubService`. `POST .../tasks/<taskId>/develop` route,
   transitions the task to `inDevelopment` then `inReview` once the PR exists.
3. `ReviewService`: second Claude Code session in the same worktree, structured Review Report,
   optional test additions committed/pushed by the server. `POST .../tasks/<taskId>/review`
   route (transitions to `awaitingApproval`); `GET .../tasks/<taskId>/pr-checks` (live, unstored);
   `POST .../tasks/<taskId>/approve` (merges via `GitHubService`, transitions to `done`).
4. UI: task detail screen gains "Start Development" (picks a Task Spec, and a Design Spec if one
   exists) and, once a PR exists, "Request Review" and an approval panel showing the Review
   Report + live pipeline check status + "Approve & Merge". Wired end to end and verified live
   against a real throwaway repo/org/PR (closed and cleaned up afterward, never a real project).

**Done when** (from ROADMAP.md): a Task Spec can go to an approved PR with you only at
checkpoints.

## Progress

(Update after each approved slice.)

- [x] 1. GitHubService + ReviewReport model
- [x] 2. DeveloperService + develop route
- [x] 3. ReviewService + review/approve/pr-checks routes
- [x] 4. Task detail UI, wired end to end, live-verified
