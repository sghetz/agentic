/// `fixed`: Claude made a change, the full pipeline passed afterward, and
/// the change was committed to a new local branch (never pushed, never
/// merged). `notTrivial`: Claude made no changes -- it judged the failure
/// too involved for the narrow trivial-fix scope. `stillFailing`: Claude
/// made a change but the pipeline still failed afterward; the attempt (and
/// its worktree/branch) is discarded.
enum HealthFixOutcome { fixed, notTrivial, stillFailing }
