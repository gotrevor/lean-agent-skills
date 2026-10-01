# Standing context for agent sessions in my Lean repos

Every one of my Lean repos `@`-includes this file into its agent context, through a gitignored `CLAUDE.local.md`.  It holds the working rules sessions keep getting wrong.  It is kept short because it loads everywhere.  Skills with the deep how-to live beside it in [`skills/`](skills/).  -Trevor

## 🧾 If it's not in Lean, it doesn't exist

Lean is the repository of what is true, what is false, what is formalized, what we believe from the literature, and what we believe from evidence.  Markdown (`PROBE-*.md`, `DIRECTION.md`, handoffs) is great for **direction**.  It is a bad place to **record** results, beliefs or counterexamples, because prose cannot be refuted by anything.

Every conclusion gets a Lean **statement** in the same turn that draws it:

| Status | Lean form |
|---|---|
| true | a theorem |
| false (refuted, counterexample) | a theorem `¬ …`, or a `decide` check; keep the refuted statement, pointed at its refutation |
| from the literature | a named hypothesis `Prop`, cited and faithful-or-weaker, never an `axiom` |
| believed (English proof or numerics) | a frozen statement with `sorry`.  Its docstring carries the confidence, the English proof, and the evidence *with its control* |
| open conjecture | a `def … : Prop` node, with its evidence and what it would imply |
| closed route | a row in the repo's `Maze.lean`, with `reopenIf` naming the new idea that would justify reopening it |

**The proof may wait; the statement may not.**  Leaving a proof unformalized is fine.  Leaving a result unstated is not.  Tell: you are about to say "recorded in PROBE-x.md", or to offer the Lean statement as optional ("if you want it in Lean").

## 🎯 New mathematics is the goal; Lean is the ledger

- Tokens go to the frontier.  Formalizing known theorems is not a destination.  A literature result enters as a hypothesis `Prop`, and discharging one is a side quest.
- **Measure a lap by the crux it advanced, not by its sorry count.**  Splitting one fat `sorry` into named leaves raises the count, and it is progress.  A refutation is progress too.
- **A conjecture needs a difficulty check:**
  - name the proved implications, the unproved premise, and the mechanism for the premise (or say none is known);
  - test the mechanism on known-false sibling systems before building on it.
- **Read the repo's negative inventory first** (`Maze.lean`, the retired lists in `DIRECTION.md`) before proposing a lemma.  An idea that survives your reasoning has often already met theirs.

## 🪜 Tiers: hypothesize, prove, formalize, publish

- `native_decide`, deprecation warnings and heartbeat boosts are fine until the **publish** tier.  Don't flag them in a report-back.
- Don't headline "axiom-clean" or "sorry-free" either; report what the mathematics says.
- **Green is not faithful.**  Guard ratified statements by name, and gate headline theorems with `#print axioms` against a baseline.  Route load-bearing claims to the compiler, not to "I checked by hand".

## 🛞 Who grinds

- Proof iteration runs on an unattended **treadmill** (Opus, low effort), not in an interactive session.  The interactive session steers: it plans phases, freezes statements, and reviews laps.
- Writing a statement with `sorry` and building it is steering, not grinding.

## 🏗️ Builds, pins and bumps

- Before `lake build` or `lake exe cache get` in a repo not yet built this session, check the shared store: `lake-base status <ver>`, then `relake plan --from ~/.lake-base/<ver> <repo>`.  "Decompressing N files" means a fresh ~7 GB tree where a ~30 MB copy-on-write clone was available.
- The `relake` dedup `--from` is always the canonical store `~/.lake-base/<ver>`, never a sibling working repo.
- **Bump mathlib only with `lean-bump <repo> --to <ver>`.**  It edits toolchain, lakefile and manifest together, and gates on build plus `#print axioms`.
  - Never use a raw `lake update`, and never hand-edit the pins.
  - If you finish a bump by hand, run `lean-bump <repo> --finish`.  That is what runs the faithfulness gate.
  - `.bump-axioms` is a transient, gitignored gate input: never commit it.
- When a bump goes red with no deprecation to follow, see the [`mathlib-bump`](skills/mathlib-bump/) skill.

## 🤝 Outward

- No mathlib PRs and no OEIS contributions while their AI policies stand.  Upstream work goes to projects that welcome it.
- Lean Zulip and leanprover-community GitHub ban LLM-written messages.  The agent supplies points and I write the post.
- Peers formalizing nearby are collaborators.  A parallel proof is independent verification, not a race.
