# Lane: formalizing known results, to publish

**Not auto-loaded.**  Read this when the user asks to formalize or publish a known result.  [`LEAN-CORE.md`](LEAN-CORE.md) is already in context through the new-math lane, so it is not imported again here.  For that work it overrides the defaults in [`LEAN-NEW-MATH.md`](LEAN-NEW-MATH.md).  Everything else in the session stays new-math.

The aim here is **published, known mathematics** that a stranger can check without trusting us.  The finish line is a faithful statement with a complete proof.

## 🏁 The finish line

- **No `sorry`.**
- **No extra axioms.**  `#print axioms` on every headline theorem shows only `propext`, `Classical.choice` and `Quot.sound`.
  - No hand-declared `axiom`.
  - No hypothesis `Prop`s standing in for literature results.  Every dependency is proved here, or comes from mathlib or a `require`d project.
- **No `native_decide`.**  Use `decide +kernel` or a real proof.
- **No unexplained `maxHeartbeats` boosts.**  No silenced linters, and no deprecated names.
- **Faithful statements.**  Read the source and cite the theorem number.  Check every hypothesis, quantifier and index base against it.  A cleaner but different statement is a different theorem.
- **Checkable by strangers:** follow the [`comparator-harness`](../skills/comparator-harness/) standard (`Challenge.lean` / `Solution.lean` / `formalization.yaml`).  Review the diff with [`lean-review`](../skills/lean-review/).  For formal-conjectures, use [`lean-erdos-review`](../skills/lean-erdos-review/).

## 🪜 Two phases

1. **Get the proof down.**  `native_decide`, deprecations, boosts and temporary `sorry`s are all fine while grinding; don't fuss.
2. **Distribution prep.**  A linter-like pass strips everything the finish line forbids.  The repo is done only when that pass is clean.

## 🧾 The record, in this lane

Statements of record are proved theorems.  A temporary `sorry` is a work item, not a belief, so it carries a short note on what remains.  An unproved claim or literature input the project genuinely needs lives in new-math territory: state it there, not in the published tree.
