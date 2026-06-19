# mathlib bump cookbook

A symptom → cause → fix catalog of **mathlib breaking changes that produce no deprecation warning** —
the ones that just leave you staring at `unsolved goals` or `made no progress` after a version bump,
with nothing to grep for.

## Why this exists

The official docs cover the *mechanics* of upgrading well
([Updating Mathlib in your project](https://leanprover-community.github.io/install/project.html)):
bump `lean-toolchain`, `lake update`, `lake exe mk_all && lake build`. What they don't cover — by design —
is **what will break and how to fix it**. The canonical answer to "what changed" is "read the
[git tags](https://github.com/leanprover-community/mathlib4/tags)," which are organized by PR, not by the
error in front of you.

For *renamed* declarations that's fine: mathlib's `@[deprecated]` aliases name their replacement in the
warning text, so a rename is self-documenting. But a whole class of breaks has **no name to alias** and so
gets no warning at all:

> **Tactic and elaboration *behavior* changes** — `convert` splitting a goal differently, `ring` now
> erroring on no-progress, `simpa`'s final check going syntactic instead of up-to-defeq, `rw`'s
> auto-closing `rfl` going reducible-transparency-only, `grind` no longer reasoning past a multiplication.

These produce a hard error or an unsolved goal with zero indication of *why*, and they're the most
time-consuming part of any bump. This catalog is aimed squarely at that gap.

## Scope

These notes were collected forward-porting several mathlib projects from the **v4.29.1** toolchain to
**v4.31.0** (skipping v4.30.0). A given change may have landed in either the 4.30 or 4.31 step — I have not
bisected which, and I'd welcome anyone who pins that down. Each entry is empirically grounded: the error
was hit in a real proof, the fix made it compile. Corrections, sharper explanations, and additions for
other version windows are very welcome — **issues and PRs open**.

## How to use it

Find your symptom in [`v4.29.1-to-v4.31.0.md`](v4.29.1-to-v4.31.0.md). Each entry gives the error you see,
what changed underneath, and a minimal fix. The patterns are grouped:

- **Behavior changes (no warning)** — the high-value ones; A–K, M.
- **Renames / signature changes that hard-error** — L, N, O (a deprecation alias was missing, `@[to_additive]`
  didn't propagate, or an argument went implicit — so you get `unknown constant` / `Function expected`, not a
  friendly warning).

The single most useful debugging technique (drop a `trace_state` and read the goal v4.31 actually produced)
is described at the top of that file.

## A note on faithfulness

A bump that compiles is not necessarily a bump that preserved your theorems. After porting, check your
headline results' axiom footprint with `#print axioms <thm>` against a pre-bump baseline — a green build
can still hide a proof whose footprint silently changed. "Green ≠ faithful" is the one habit worth keeping.

## License

[Apache License 2.0](LICENSE), Copyright 2026 Trevor Morris — matching mathlib, Lean, and the rest of the
ecosystem, so snippets copy into your mathlib project with zero license friction.
