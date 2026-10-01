@LEAN-CORE.md

# Lane: new mathematics

This repo pushes on **open questions**.  The goal is new mathematics.  Lean is the ledger it is written in, not the goal, so formalizing known theorems for their own sake is not where effort goes.

## 🧾 If it's not in Lean, it doesn't exist

Every conclusion gets a Lean **statement** in the same turn that draws it.  The proof may wait; the statement may not.

| Status | Lean form |
|---|---|
| true | a theorem |
| false (refuted, counterexample) | a theorem `¬ …`, or a `decide` check; keep the refuted statement, pointed at its refutation |
| from the literature | a named hypothesis `Prop`, cited and faithful-or-weaker, never an `axiom` |
| believed (English proof or numerics) | a frozen statement with `sorry`.  Its docstring carries the confidence, the English proof, and the evidence *with its control* |
| open conjecture | a `def … : Prop` node, with its evidence and what it would imply |
| closed route | a row in the repo's `Maze.lean`, with `reopenIf` naming the new idea that would justify reopening it |

Tell: you offer the Lean statement as optional ("if you want it in Lean"), or a finding's only home is a `PROBE-` file.

## ✅ Encouraged here (and wrong in the formalize lane)

- **Literature results as hypothesis `Prop`s.**  State the published theorem, cite it, and build on it.  Discharging one is a side quest.  Check the transcription against the source anyway: a wrong `Prop` is still better than prose, because a lap can refute it.
- **`sorry` with a confidence** on a statement we believe and have not proved.
- **`native_decide`, deprecation warnings and `maxHeartbeats` boosts.**  These are publish-tier concerns, and this lane does not publish.  Don't flag them in a report-back.
- Don't headline "axiom-clean" or "sorry-free" either.  Report what the mathematics says.

## 📏 How progress is measured

- **A lap is measured by the crux it advanced, not by its sorry count.**  Splitting one fat `sorry` into named leaves raises the count, and it is progress.  A refutation is progress too.
- **A conjecture needs a difficulty check:**
  - name the proved implications, the unproved premise, and the mechanism for the premise (or say none is known);
  - test the mechanism on known-false sibling systems before building on it.
- **Read the repo's negative inventory first** (`Maze.lean`, the retired lists in `DIRECTION.md`) before proposing a lemma.  An idea that survives your reasoning has often already met the repo's.
- **Check for prior work.**  A paper's "open question" is a dated claim: look at forward citations and open PRs before treating it as open.
