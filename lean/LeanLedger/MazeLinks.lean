/-
Copyright (c) 2026 Trevor Morris. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Trevor Morris
-/
import Lean

/-!
# Maze links: every closed route rests on statements

A research repo keeps a register of closed routes, a `Maze.lean`: one row per walked hall, with
a verdict and a few sentences of reasons.  Sentences in a string literal are prose, and the
compiler never reads them.  This file makes the register **cite declarations**.

* A `Link` ties a row to the declarations its verdict rests on (`decls`): the obstruction as a
  theorem, a `¬`, a `sorry` statement with a confidence, or a `Literature` Prop.  It can also
  name the `def … : Prop` that would reopen the route (`reopen`).
* Names are written as ``` ``Foo.bar ``` literals.  The elaborator rejects a name that does not
  exist, so a link cannot cite a missing declaration, and a rename breaks the build.
* `#maze_audit rows, links, legacy` fails the build unless
  - every row outside `legacy` has a link with at least one declaration;
  - every row that needs a reopen condition (typically `wall`) has one;
  - no link names an unknown row, and no legacy entry names an unknown row;
  - no legacy entry has gained a link.  Such an entry must be deleted from `legacy`, so the
    legacy list only shrinks.

`legacy` is the backlog: rows written before the audit existed, whose reasons are still prose.
New rows cannot join it without an edit that a reviewer sees.
-/

namespace LeanLedger

open Lean Elab Command

/-- What the audit needs to know about one register row. -/
structure RowInfo where
  /-- The row's name, as written in the register. -/
  name : String
  /-- Whether the row must name the statement that would reopen it (typically `wall` rows). -/
  needsReopen : Bool
  deriving Repr

/-- A row's Lean record.  Write the names as ``` ``Foo.bar ``` literals. -/
structure Link where
  /-- The register row this link belongs to. -/
  row : String
  /-- The declarations the verdict rests on. -/
  decls : List Name
  /-- The `def … : Prop` nodes whose truth would reopen the route. -/
  reopen : List Name := []
  deriving Repr

/-- The audit's findings, one line each.  Empty means the register passes. -/
def audit (rows : List RowInfo) (links : List Link) (legacy : List String) : List String :=
  let rowNames := rows.map (·.name)
  let linked (r : String) : Bool := links.any (fun l => l.row == r && !l.decls.isEmpty)
  let reopened (r : String) : Bool := links.any (fun l => l.row == r && !l.reopen.isEmpty)
  let unlinked := (rows.filter (fun r => !linked r.name && !legacy.contains r.name)).map
    (fun r => s!"row \"{r.name}\" cites no declaration: add a Link (its reasons are prose only)")
  let noReopen := (rows.filter (fun r =>
      r.needsReopen && !legacy.contains r.name && !reopened r.name)).map
    (fun r => s!"row \"{r.name}\" names no reopen Prop")
  let dangling := (links.filter (fun l => !rowNames.contains l.row)).map
    (fun l => s!"link for unknown row \"{l.row}\"")
  let staleLegacy := (legacy.filter (fun g => !rowNames.contains g)).map
    (fun g => s!"legacy entry \"{g}\" names no row")
  let graduated := (legacy.filter linked).map
    (fun g => s!"legacy entry \"{g}\" now has a link: delete it from the legacy list")
  unlinked ++ noReopen ++ dangling ++ staleLegacy ++ graduated

/-- One-line summary for a passing register. -/
def summary (rows : List RowInfo) (links : List Link) (legacy : List String) : String :=
  let linked := (rows.filter (fun r => links.any (fun l => l.row == r.name && !l.decls.isEmpty))).length
  s!"maze audit: {rows.length} rows, {linked} cite declarations, {legacy.length} legacy (prose only)"

/-- Evaluate `audit` and `summary` at elaboration time. -/
unsafe def evalAudit (rows links legacy : Term) : TermElabM (List String × String) := do
  let ty ← Term.elabType (← `(List String × String))
  let stx ← `((LeanLedger.audit $rows $links $legacy, LeanLedger.summary $rows $links $legacy))
  Term.evalTerm (List String × String) ty stx

/-- `#maze_audit rows, links, legacy` fails the build unless every non-legacy row cites a
declaration.  See the module docstring for the full list of checks. -/
elab "#maze_audit " rows:term ", " links:term ", " legacy:term : command => do
  let (problems, info) ← liftTermElabM (unsafe evalAudit rows links legacy)
  if problems.isEmpty then
    logInfo info
  else
    throwError "maze audit failed ({problems.length}):\n{"\n".intercalate problems}"

end LeanLedger
