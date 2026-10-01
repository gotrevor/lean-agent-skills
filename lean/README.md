# LeanLedger

Lean-core-only helpers for research repos that keep their conclusions in Lean.

## `#maze_audit`: closed routes rest on statements

A `Maze.lean` register records closed routes as rows of prose.  `LeanLedger.MazeLinks` makes the
rows cite declarations:
- the obstruction: a theorem, a `¬`, a `sorry` statement with a confidence, or a `Literature`
  Prop;
- for walls, the `def … : Prop` that would reopen the route.

The names are ``` ``Foo.bar ``` literals, so a missing or renamed declaration breaks the build.

```lean
import LeanLedger.MazeLinks
open LeanLedger

def mazeRows : List RowInfo := register.map fun h => ⟨h.name, decide (h.verdict = .wall)⟩

def mazeLinks : List Link := [
  ⟨"site factorization via log-power BV",
   [``card_siteAssignments], [``DepthUniformMultBV]⟩ ]

/-- Rows written before the audit; their reasons are still prose.  This list only shrinks. -/
def mazeLegacy : List String := [ "(BL) bias-loss criterion", … ]

#maze_audit mazeRows, mazeLinks, mazeLegacy
```

The audit fails the build when:
- a non-legacy row has no link;
- a row that needs a reopen condition has none;
- a link or a legacy entry names an unknown row;
- a legacy row has gained a link (delete it from the legacy list).

Require it from a Lean repo (`lakefile.toml`):

```toml
[[require]]
name = "LeanLedger"
git = "https://github.com/gotrevor/lean-agent-skills.git"
rev = "<sha>"
subDir = "lean"
```

Tests: `lake build` in this directory builds `LeanLedger.Tests`, which pins every failure message
with `#guard_msgs`.
