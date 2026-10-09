/// A simplified view over GitHub's per-check-run `status`/`conclusion` pair
/// (and legacy commit statuses, which use the same shape) -- just enough to
/// decide whether the owner should wait before approving.
enum PrCheckConclusion { pending, success, failure, neutral }
