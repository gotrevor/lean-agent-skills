/-
Copyright (c) 2026 Trevor Morris. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Trevor Morris
-/
import LeanLedger.MazeLinks

/-!
# Tests for `#maze_audit`

Each red case states its expected message, worked out from `audit`'s format strings.  The green
cases show the check passes when it should.
-/

namespace LeanLedger.Tests

theorem toyObstruction : True := trivial

/-- A reopen condition. -/
def ToyReopen : Prop := True

def toyRows : List RowInfo := [⟨"wall row", true⟩, ⟨"refuted row", false⟩]

/-- info: maze audit: 2 rows, 2 cite declarations, 0 legacy (prose only) -/
#guard_msgs in
#maze_audit toyRows,
  [⟨"wall row", [``toyObstruction], [``ToyReopen]⟩, ⟨"refuted row", [``toyObstruction], []⟩], []

/-- info: maze audit: 2 rows, 0 cite declarations, 2 legacy (prose only) -/
#guard_msgs in
#maze_audit toyRows, [], ["wall row", "refuted row"]

/--
error: maze audit failed (2):
row "refuted row" cites no declaration: add a Link (its reasons are prose only)
row "wall row" names no reopen Prop
-/
#guard_msgs in
#maze_audit toyRows, [⟨"wall row", [``toyObstruction], []⟩], []

/--
error: maze audit failed (3):
link for unknown row "ghost"
legacy entry "gone" names no row
legacy entry "refuted row" now has a link: delete it from the legacy list
-/
#guard_msgs in
#maze_audit toyRows,
  [⟨"wall row", [``toyObstruction], [``ToyReopen]⟩, ⟨"refuted row", [``toyObstruction], []⟩,
   ⟨"ghost", [``toyObstruction], []⟩], ["refuted row", "gone"]

-- An empty `decls` list does not count as a link.
/--
error: maze audit failed (1):
row "refuted row" cites no declaration: add a Link (its reasons are prose only)
-/
#guard_msgs in
#maze_audit toyRows,
  [⟨"wall row", [``toyObstruction], [``ToyReopen]⟩, ⟨"refuted row", [], []⟩], []

-- A link cannot cite a declaration that does not exist: the name literal fails to elaborate.
/--
error: Unknown constant `doesNotExist`
---
error: Unknown constant `doesNotExist`
---
error: cannot evaluate code because 'sorryAx' uses 'sorry' and/or contains errors
-/
#guard_msgs in
#maze_audit toyRows, [⟨"wall row", [``doesNotExist], [``ToyReopen]⟩], ["refuted row"]

end LeanLedger.Tests
