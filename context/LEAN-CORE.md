# Lean sessions: the shared core

Shared rules for agent sessions in my Lean repos, loaded once through [`LEAN-NEW-MATH.md`](LEAN-NEW-MATH.md).  -Trevor

## 🧾 Lean is the record

Lean statements are where conclusions live: what is true, what is false, what is formalized, and what is assumed.  Markdown (`README`, `DIRECTION.md`, `PROBE-*.md`, handoffs) is for **direction**: plans, provenance, and why a route was chosen.  Prose is a bad place to *record* a result or a counterexample, because nothing can refute prose.

Tell: you are about to say "recorded in X.md" and no `.lean` file changed.  What counts as an acceptable Lean form differs by lane; see the lane file.

## 🎯 Faithfulness

- **Green is not faithful.**
  - Guard ratified statements by name.
  - Gate headline theorems with `#print axioms` against a baseline.
  - Route load-bearing claims to the compiler.  "I checked it by hand" is the confabulation tell.
- **Never fabricate a reference, a theorem number or a hypothesis.**  Open the source and read past the paragraph you needed.
- A negative result needs a known-answer control: run the same probe on a case where the answer is known.

## 🛞 Who grinds

- Proof iteration runs on an unattended **treadmill** (Opus, low effort), not in an interactive session.
- The interactive session steers: it plans phases, freezes statements, and reviews laps.
- Writing a statement and building it is steering, not grinding.

## 🏗️ Builds, pins and bumps

- **Before `lake build` or `lake exe cache get`** in a repo not yet built this session, check the shared store: `lake-base status <ver>`, then `relake plan --from ~/.lake-base/<ver> <repo>`.
  - "Decompressing N files" means a fresh ~7 GB tree, when a ~30 MB copy-on-write clone was available.
  - The `relake` dedup `--from` is always the canonical store `~/.lake-base/<ver>`, never a sibling working repo.
- **Bump mathlib only with `lean-bump <repo> --to <ver>`.**  It edits toolchain, lakefile and manifest together, and gates on build plus `#print axioms`.
  - Never use a raw `lake update`, and never hand-edit the pins.
  - If you finish a bump by hand, run `lean-bump <repo> --finish`.  That is what runs the faithfulness gate.
  - `.bump-axioms` is a transient, gitignored gate input; never commit it.
  - When the build goes red with no deprecation to follow, use the [`mathlib-bump`](../skills/mathlib-bump/) skill.

## 🤝 Outward

- **Read the target repo's own `AGENTS.md` / `CONTRIBUTING`** before writing for it.
- No mathlib PRs and no OEIS contributions while their AI policies stand.
- Lean Zulip and leanprover-community GitHub ban LLM-written messages.  The agent supplies points; I write the post.
- Peers formalizing nearby are collaborators.  A parallel proof is independent verification, not a race.

## 🗺️ On my machine

These pointers resolve only on my Mac and in my treadmill box.  Elsewhere, skip them.
- **Before substantial Lean work, read** `~/personal/claude/knowledge/core/decisions/lean-decisions.md`.  It covers the comparator standard, the CI maturity ladder, faithfulness audits, dependency re-homing, machinery walls and the target catalog.
- `.lake`, pins and the shared store are a known blind spot.  Read `~/personal/claude/knowledge/core/projects/lean-universe-architecture.md` and `~/src/lean-universe/LAKE-BASE-DESIGN.md` before touching them.
- History behind these rules:
  - `~/personal/claude/knowledge/core/decisions/lean-is-the-record.md`;
  - `literature-results-as-hypothesis-props.md` and `agent-operated-treadmills.md`, both in the same folder.
- Lean reference corpus (tactic gotchas, mathlib facts): `~/personal/claude/knowledge/core/projects/lean-journey/reference/`.
