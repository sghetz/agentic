/// `prOpened`: Claude made a change, the full pipeline passed afterward, the
/// change was committed, pushed, and a PR was opened. `verificationFailed`:
/// Claude made a change but the pipeline failed afterward -- committed
/// locally (never pushed, never a PR) so the attempt isn't lost; the owner
/// or a later retry can continue from the same worktree. `noChanges`:
/// Claude made no changes at all. `sessionFailed`: the Claude Code session
/// itself crashed or timed out before producing anything.
enum DeveloperOutcome { prOpened, verificationFailed, noChanges, sessionFailed }
