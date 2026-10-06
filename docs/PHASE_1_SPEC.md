# Phase 1 Spec

Health agent: deterministic repo onboarding (clone, detect) and build/lint/test pipeline,
Health Reports in the UI, dartantic_ai diagnosis on failure, Claude Code trivial-fix subprocess.

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

## Build order

1. Repo tracking + clone/detect onboarding
2. Deterministic health pipeline + Health Reports (artifact schema change, build queue,
   `fvm flutter pub get -> analyze -> test -> build apk -> build ios --no-codesign`, status UI,
   one-click "check all projects")
3. dartantic_ai failure diagnosis (classify: dependency, SDK mismatch, code break, flaky test,
   environment)
4. Claude Code trivial-fix subprocess on a branch (version bumps, build_runner regen) -- never
   pushes to main, never merges

**Done when** (from ROADMAP.md): one click checks all projects and failures come with a diagnosis.

## Progress

(Update after each approved slice.)

- [x] 1. Repo tracking + onboarding
- [ ] 2. Deterministic health pipeline + Health Reports
- [ ] 3. dartantic_ai diagnosis
- [ ] 4. Claude Code trivial-fix subprocess
