# Lean sessions: the shared core

Shared rules for agent sessions in a Lean repo, loaded once through a lane sheet: [`LEAN-NEW-MATH.md`](LEAN-NEW-MATH.md) in our own repos, [`LEAN-UPSTREAM.md`](LEAN-UPSTREAM.md) in a project with its own contract.  Where a project's own `AGENTS.md` or `CONTRIBUTING` disagrees with this sheet, the project wins.

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

- Proof iteration belongs in an unattended loop, not in an interactive session.
- The interactive session steers: it plans phases, freezes statements, and reviews the loop's output.
- Writing a statement and building it is steering, not grinding.

## 🏗️ Pins and bumps

- Never hand-edit the toolchain, lakefile or manifest pins one at a time, and never run a bare `lake update` to "fix" a build.  Bump all three together, then gate on the build plus `#print axioms` of the headline theorems.
- When a bump goes red with no deprecation to follow, use the [`mathlib-bump`](../skills/mathlib-bump/) skill.

## 🤝 Outward

- **Read the target repo's own `AGENTS.md` / `CONTRIBUTING`** before writing for it.
- Check a venue's AI policy before contributing to it.
- Lean Zulip and leanprover-community GitHub ban LLM-written messages.  The agent supplies points; the human writes the post.
- Peers formalizing nearby are collaborators.  A parallel proof is independent verification, not a race.

@~/personal/claude/lean-personal.md
