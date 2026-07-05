# lean-agent-skills

Practical, empirically-grounded **skills for AI-assisted Lean 4 + Mathlib work** — the
know-how an agent (or a human) needs to contribute formalizations and survive version
bumps without tripping over the ecosystem's unwritten rules.

Each skill is a self-contained directory under [`skills/`](skills/) with a `SKILL.md`:
readable on its own, and shaped as a [Claude Code / Agent skill](https://docs.claude.com/en/docs/claude-code/skills)
(YAML frontmatter + instructions) so you can drop it into an agent that supports the format.

> Formerly **`mathlib-bump-cookbook`** — renamed and broadened once the review skills
> outgrew a single catalog. The old URL 301-redirects here, so existing links keep working.

## Skills

| Skill | Use it when |
|-------|-------------|
| [`mathlib-bump`](skills/mathlib-bump/) | A `lake build` goes red after a Mathlib version bump and the errors have **no deprecation warning** to grep for (`unsolved goals`, `made no progress`, `unknown constant`). Symptom → cause → fix catalog; first window v4.29.1 → v4.31.0. |
| [`lean-review`](skills/lean-review/) | Reviewing a Lean **diff** for trust/hygiene smells — new `maxHeartbeats`, `native_decide`, hand-declared `axiom`, `sorry`, silenced linters, escapes from the kernel. The things that quietly expand the trusted base or hide a hole, especially in AI/agent-produced proofs. |
| [`lean-erdos-review`](skills/lean-erdos-review/) | Preparing or reviewing a submission to [formal-conjectures](https://github.com/google-deepmind/formal-conjectures) (especially Erdős problems) against the project's house style: statement faithfulness, `answer()`, `.variants.*`, LaTeX-not-backtick docstrings, and references verified against source. |

## Why this exists

AI can now produce a *lot* of Lean, fast. What it can't reliably do yet is the last mile:
notice that a proof only compiles because someone raised `maxHeartbeats`, that a docstring
put math in backticks instead of LaTeX, that a "solved" Erdős file quietly dropped the
variants the source lists, or that a green build after a bump silently changed a theorem's
axiom footprint. These skills encode the review passes and migration lore that catch exactly
those things — the parts that are boring to rediscover and expensive to get wrong.

Every entry is grounded in real projects: errors hit in real proofs, conventions confirmed
against the upstream maintainers' own docs and review threads. Corrections and additions
welcome — **issues and PRs open**.

## License

[Apache License 2.0](LICENSE), Copyright 2026 Trevor Morris — matching Mathlib, Lean, and
the rest of the ecosystem, so snippets copy into your project with zero license friction.
