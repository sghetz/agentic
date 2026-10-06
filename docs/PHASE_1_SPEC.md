# Phase 1 Spec

Health agent: deterministic repo onboarding (clone, detect) and build/lint/test pipeline,
Health Reports in the UI, Claude Code CLI diagnosis on failure, Claude Code trivial-fix subprocess.

## Decisions

- **Artifact schema**: `taskId` becomes nullable; `Artifact` gains an optional `projectId`.
  Exactly one of the two is set. Health Reports (`kind: healthReport`) attach to `projectId`;
  every other kind continues to attach to `taskId` as in Phase 0.
- **Repos on disk**: `~/Agentic/repos/<org_slug>/<project_slug>/`, per the architecture doc.
  Computed deterministically from org+project slugs by the server, not user-editable.
- **Flutter version detection** only trusts an explicit FVM pin (`.fvmrc` or
  `.fvm/fvm_config.json`) in the cloned repo; never guesses from the Dart SDK constraint in
  pubspec.yaml, since that doesn't determine a Flutter version on its own. Undetected -> `null`.
- **Onboarding (clone + detect) is synchronous** over HTTP for Phase 1 -- single-user local app,
  one project at a time. The sequential **build queue** is introduced in slice 2 for the slower
  build/lint/test pipeline specifically, not for onboarding.
- **Diagnosis uses Claude Code CLI non-interactively, not dartantic_ai + a separate Anthropic API
  key.** `claude -p "<prompt>" --output-format json --json-schema <schema> --tools "" --model
  haiku --no-session-persistence --max-budget-usd 0.50`. Reuses whatever Claude Code auth is
  already on the machine (often zero marginal cost on a subscription) instead of adding metered
  API billing; `--tools ""` means it only ever classifies the text we hand it, no file/repo
  access. Best-effort: a failed health check is still useful without a diagnosis attached, so a
  diagnosis error never fails the health check itself. Not covered by the automated test suite
  (it costs real money and takes several seconds per call) -- verified live once per change
  instead; the service layer is tested via an injectable fake invoker.

## Build order

1. Repo tracking + clone/detect onboarding
2. Deterministic health pipeline + Health Reports (artifact schema change, build queue,
   `fvm flutter pub get -> analyze -> test -> build apk -> build ios --no-codesign`, status UI,
   one-click "check all projects")
3. Claude Code CLI failure diagnosis (classify: dependency, SDK mismatch, code break, flaky test,
   environment)
4. Claude Code trivial-fix subprocess on a branch (version bumps, build_runner regen) -- never
   pushes to main, never merges

**Done when** (from ROADMAP.md): one click checks all projects and failures come with a diagnosis.

## Progress

(Update after each approved slice.)

- [x] 1. Repo tracking + onboarding
- [x] 2. Deterministic health pipeline + Health Reports
- [x] 3. Claude Code CLI failure diagnosis
- [x] 4. Claude Code trivial-fix subprocess
