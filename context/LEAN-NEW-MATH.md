@LEAN-CORE.md

# Lane: new mathematics

This is the default lane.  The goal is **new mathematics**.  Lean is the ledger it is written in, not the goal, so formalizing known theorems for their own sake is not where effort goes.

**Cue to switch lanes:** when the user asks to formalize or publish a known result ("formalize X", "get this ready to publish", "no sorry"), read [`LEAN-FORMALIZE.md`](LEAN-FORMALIZE.md) before starting.  For that work, its finish line overrides the "encouraged" list below.

## 🧾 If it's not in Lean, it doesn't exist

Every conclusion gets a Lean **statement** in the same turn that draws it.  The proof may wait; the statement may not.

**Statement first, prose second.**  Write the declaration before the paragraph that explains it.  The doc then cites the declaration by name.  A doc written first absorbs the specifics, and the Lean pass afterwards records only the headline.

| Status | Lean form |
|---|---|
| true | a theorem |
| false (refuted, counterexample) | a theorem `¬ …`, or a `decide` check; keep the refuted statement, pointed at its refutation |
| from the literature | a named hypothesis `Prop`, cited and faithful-or-weaker, never an `axiom` |
| believed (English proof or numerics) | a frozen statement with `sorry`.  Its docstring carries the confidence, the English proof, and the evidence *with its control* |
| open conjecture | a `def … : Prop` node, with its evidence and what it would imply |
| closed route | a row in the repo's `Maze.lean` whose verdict rests on statements: the obstruction as a theorem (or `sorry` with confidence), and the reopen condition as a `def … : Prop` node.  The row names both, through [`#maze_audit`](../lean/README.md), which fails the build on a prose-only row |

Tells:
- You offer the Lean statement as optional ("if you want it in Lean").
- A finding's only home is a `PROBE-` file.
- **A finding's only Lean home is a string**: a docstring, or the text of a `Maze.lean` row.  Prose inside a `.lean` file is still prose.  The compiler checks the statement and never reads the string, so "a `.lean` file changed" proves nothing.
- A refereed or self-corrected argument whose corrections went into the doc.  Each correction is a conclusion: a weakened statement, a withdrawn step, a newly named missing estimate.

**Report-back check:** every conclusion in a report-back names the declaration that records it.  A conclusion with no name to cite has not been recorded.

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
