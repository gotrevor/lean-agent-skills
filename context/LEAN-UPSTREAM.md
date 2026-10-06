@LEAN-CORE.md

# Lane: contributing to someone else's project

Use this lane in a repo whose maintainers set the rules: an upstream project with its own `AGENTS.md`, `CONTRIBUTING`, or documented workflow.  Their contract governs the work.  This sheet only adds what holds everywhere.

## 📜 The repo's contract wins

- **Read the repo's `AGENTS.md`, `CONTRIBUTING` and workflow docs before the first edit**, and follow them as written.  Where they disagree with any sheet in this directory, they win.
- **Their rules on unproved statements are the rules.**  Use whatever form the project prescribes (a named `axiom` with an audit entry, a `sorry`-free tree, a statement-then-proof PR pair).  The research-lane forms do not apply here: no `sorry` with a confidence, no literature hypothesis `Prop`s, no `Maze.lean` rows, no `@[blueprint]` tags, no `docs/notes/` pages, unless the project itself uses them.
- **Their scope is the scope.**  Build only what the project's plan asks for (its open issues, its roadmap).  A gap or a new idea goes where the project says gaps go, usually the thread of the issue being worked on.  Research of our own belongs in a repo we own.
- **Their process owns the pins, branches, labels and merges.**  The generic bump and build advice in the core sheet yields to it.

## 🧾 Lean is still the record

A conclusion still needs a Lean statement, in the project's own form and in the place its process puts it.  When the project has no slot for a finding (an idea outside its plan, a refuted approach), record it in a repo we own and point to it from the project's thread.

## 🤝 Outward

- Disclose AI involvement exactly as the project asks: trailers, PR-body wording, session links.
- PR titles, bodies and review replies follow the project's conventions.  The human whose name is on the account sends anything written in their voice.
