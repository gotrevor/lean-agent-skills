---
name: comparator-harness
description: >-
  Add (or review) a `Challenge.lean` / `Solution.lean` / `comparator` / `formalization.yaml`
  harness on a Lean 4 project — the de-facto submission standard for AI-assisted
  formalizations. Use when publishing a formalization you want strangers to be able to
  *check without trusting you*, when a maintainer asks for "a challenge and solution file",
  or when reviewing someone else's harness. Covers what it does and does not buy, the
  layout, the seven things that bite, and which duplication is load-bearing.
---

# comparator-harness 🔐

Wire [`leanprover/comparator`](https://github.com/leanprover/comparator) into a Lean project: a
**`Challenge.lean`** stating your headline results against Mathlib alone, a **`Solution.lean`**
discharging them from your development, and CI that machine-checks the two agree — under a
**second, independent kernel**, inside a sandbox, with an axiom whitelist.

> **This does not tell you the statements are right.** It tells you the proofs are honest *about
> whatever you stated*. Those are different guarantees, and confusing them is the single most
> common error in this space. See [What it does not buy](#-what-it-does-not-buy-read-this-twice).

## Why this exists: the standard is now the entry ticket 🎟️

AI can produce a lot of Lean, fast. The Lean community's response, hammered out on the Zulip
channel [`#AI authored projects`](https://leanprover.zulipchat.com/#narrow/channel/583339-AI-authored-projects)
through 2026, is a **submission standard** — and it is enforced bluntly, because maintainers are
triaging many such projects a day.

**Kevin Buzzard**, stating it canonically:

> "What the community needs in order to judge work such as this is a `Challenge.lean` and
> `Solution.lean` file with the challenge file just importing mathlib and the solution file
> importing your code (so that we can (a) immediately see what your claims are in a formal language
> and (b) use comparator to check that your claims are valid) and a description of how you used AI
> in a `formalization.yaml` file."

**Kim Morrison**, on what happens without it: *"Without clear answers to these questions a project
like this is just slop."* And Buzzard again: *"it is those who conform to the comparator and
formalization.yaml frameworks who will get the attention."*

**The four pillars:**

1. **`Challenge.lean`** — imports *only Mathlib*; defines every notion it uses; states the headline
   theorems as `sorry`. This is the **human audit surface**. Keep it small; expose only top-level
   results.
2. **`Solution.lean`** — imports your project; discharges them.
3. **`comparator` in CI** — exports both environments, matches the statements, replays the proofs
   under Lean's kernel **and** the independent [`nanoda`](https://github.com/ammkrn/nanoda_lib)
   kernel, and enforces a `permitted_axioms` whitelist. Kim Morrison's public
   [lean-eval](https://lean-lang.org/eval/) leaderboard is built on it.
4. **[`formalization.yaml`](https://github.com/mathlib-initiative/formalization.yaml)** — models,
   harness, cost, and which parts a human actually did. Disclose AI authorship at the **top of the
   README**, not buried.

The deeper motivation is one sentence: **it is what lets a stranger check your repo without
trusting you.** Buzzard, plainly: *"I am not going to download a bunch of AI-generated code off the
internet and run it... but I would run comparator against it if it had been set up."* That is the
whole argument for the sandbox, and the whole argument for doing this at all.

## 📉 What it buys, honestly

Be clear-eyed. If you already gate `#print axioms` on your headlines, comparator adds **little
self-assurance** and **a great deal of external legibility**.

| | a `#print axioms` gate | comparator |
|---|---|---|
| axiom whitelist | ✅ and you can *pin* it exactly with `#guard_msgs` (**stricter**) | ✅ whitelist only |
| statement fixed to a **Mathlib-only** rendering | ⚠️ your `Statement.lean` still imports your own code | ✅ tighter |
| runs **outside** your elaborator and your oleans | ❌ | ✅ exports the terms and replays them |
| **second independent kernel** (`nanoda`) | ❌ | ✅ **the one real assurance gain** |
| adversary-proof (`landrun` sandbox) | ❌ | ✅ — for *your readers*, not for you |

Two things follow, and both are easy to get wrong:

- 👉 **Turn `enable_nanoda: true` on.** It is the only line in the config that buys you genuinely new
  trust: your assumption weakens from *"Lean's kernel is correct"* to *"Lean's kernel **or**
  nanoda's is correct."* It is off by default and easy to forget.
- **`landrun` protects the verification *process*, not the mathematics.** Lean elaboration runs
  arbitrary code, so an adversarial `Solution.lean` could rewrite `Challenge.olean` mid-build and
  make the judge compare against the wrong statement. For checking *your own* repo that is worth
  approximately zero. It is worth everything to the stranger who wants to check you without running
  your code.

## 🚩 What it does not buy (read this twice)

Comparator proves the solution establishes **the challenge's** statements. It is structurally
incapable of telling you those statements say what the mathematics says.

> "The comparator lets you be sure it didn't use certain trickery to prove what is written, **but if
> all the definitions are made by an AI, all you know is that no hacks were used to prove whatever
> it is that it concocted.** ... To be certain it actually says the mathematical statement you want,
> you'd need to look closely and examine the definitions." — Yan Yablonovskiy

The cautionary miniature: a formalization of **Napoleon's theorem** compiled, was axiom-clean, and
proved *nothing* — the AI had redefined `IsEquilateral` as an algebraic identity that made the
result a triviality. It would have sailed through comparator.

**So the review is: read the `Challenge.lean` definitions.** Not the theorems — the *definitions*. A
statement can only lie through the notions it names. That is why the challenge file must be small,
and why keeping it small is a design goal rather than an aesthetic one.

## 🧬 Which duplication is load-bearing (the DRY question)

The first reaction to a finished harness is always *"my `Challenge.lean` is just a copy of my project
— surely there's a DRYer way."* Half right. There are **two** copies, and they are completely
different animals.

**Copy 1 — `Challenge.lean` ↔ your development. Load-bearing. Keep it.**

This is not redundancy; it *is* the check. The challenge is an independent, Mathlib-only rendering of
your claims, and comparator's core guarantee is that this rendering is **byte-identical** (same
`ConstantInfo`) to what your development actually proves. Two ways to "DRY" it, both of which destroy
the thing being certified:

- ❌ *Have the challenge import your definitions.* Now the reader must trust your import closure to
  read your claims, and comparator compares a thing to itself. The Mathlib-only import is the entire
  point.
- ❌ *Generate the challenge from your source.* Now you are pretty-printing your own code and checking
  it equals itself. Tautology. (And the generated file is no longer the *human* audit surface, which
  is the one job it has.)

Drift between the two copies is the real worry — and it is fully handled: comparator **is** the drift
detector, and it goes red in CI the moment they diverge. Make it a required status check and the
duplication becomes maintenance-free.

**Copy 2 — `Challenge.lean` ↔ `Solution.lean`. Pure waste. Delete it.**

The tempting shape is: challenge declares `MyChallenge.foo` under a fresh namespace, solution
*re-declares the same definition* and delegates to `MyProject.foo`. That copies every definition a
third time, and on top of it you end up writing bridge lemmas (`foo_eq : MyChallenge.foo = MyProject.foo`)
whose only reason to exist is the duplication you just created.

🏆 **The strong pattern — use it by default:**

> **`Challenge.lean` declares your project's constants under their real fully-qualified names**
> (still importing only Mathlib, still written out in full). **`Solution.lean` imports the project
> and declares nothing.**

```lean
-- Challenge.lean          -- imports ONLY Mathlib
namespace MyProject.Widgets
def foo (n : ℕ) : ℕ := …            -- the real body, written out, auditable on its own terms
theorem foo_bounded : ∀ n, foo n ≤ 7 := sorry
end MyProject.Widgets
```
```lean
-- Solution.lean
import MyProject.Widgets.Statement   -- that's it. `MyProject.Widgets.foo_bounded` is already there.
```

Comparator seeds its worklist from the challenge theorem's `type.getUsedConstants`, walks the
closure (including inductives' constructors), and demands an identical `ConstantInfo` for each. So it
certifies **your genuine constants** — not an isomorphic stunt double — with **zero glue code on the
trust path**, and the solution collapses to an import list. Reusing your namespace does *not* force
you to import your project.

*(Caveat: a module importing both the challenge and the library would hit duplicate declarations.
Nothing should, and nothing does — the challenge lib is not in `defaultTargets`.)*

**When the solution legitimately declares something:** only when the challenge **deliberately
restates** a theorem, e.g. giving an *existential* form (`∃ a counterexample …`) where your
development has an explicit construction. That is often the right call — it keeps the witness
construction out of the trusted closure, shrinking the audit surface *and* tracking the source more
faithfully. Then the solution carries a one-line derivation. Definitions, still, never get copied.

## 🗂️ Layout

```
Comparator/<Result>/Challenge.lean   -- imports ONLY Mathlib; real bodies; headlines := sorry
Comparator/<Result>/Solution.lean    -- imports the development; ideally declares nothing
Comparator/<Result>/config.json      -- theorem_names + permitted_axioms + enable_nanoda
Comparator.lean                      -- lean_lib root
```

```toml
# lakefile.toml
[[lean_lib]]
name = "Comparator"
globs = ["Comparator.+"]
```

Keep the `Comparator` lib **out of `defaultTargets`** and **out of your library root's imports** —
challenge files carry `sorry` by design and most projects build warnings-as-errors. Each
`Challenge.lean` needs `set_option warningAsError false`.

```json
{
  "challenge_module": "Comparator.Widgets.Challenge",
  "solution_module": "Comparator.Widgets.Solution",
  "theorem_names": ["MyProject.Widgets.foo_bounded"],
  "permitted_axioms": ["propext", "Quot.sound", "Classical.choice"],
  "enable_nanoda": true
}
```

## ⚠️ The seven things that bite

**1. `lean4export` must match YOUR project's Lean version.** Comparator ships on its own (usually
newer) toolchain, and its bundled `lean4export` will refuse your oleans with
`failed to read file ... incompatible header`. Build `lean4export` at the tag matching your
`lean-toolchain` (it carries per-version tags, e.g. `v4.31.0`) and pin it in CI. This is the classic
first-red-run.

**2. Never use definition holes.** Comparator's `definition_names` checks only a hole's **name, type,
universe and safety** — *not its body*. Its own README says such a solution "can be gamed without
additional oversight" and "**must** always be checked with an additional (potentially human)
verifier." Give every definition its **real body** instead: it then falls under the strict identity
check (*"all declarations used in the statement ... are the same as in the Solution environment"*),
which compares full `ConstantInfo`s. Strictly stronger, and not gameable. **If you take one thing
from this skill, take this one.**

**3. Recursive / well-founded / inductive definitions cannot be duplicated-and-delegated.** The naive
shape (challenge declares a copy, solution redeclares it and delegates to the project) leans on two
same-bodied constants being defeq. Fine for plain `def`s. It **fails** for:
- **equation-compiler recursions** — `brecOn` bodies don't cross-unfold;
- **well-founded defs** — Lean marks them **irreducible**;
- **inductives** — generative, so a duplicate is a genuinely *different type*.

Both fixes are the ones above: **the strong pattern** (real names, solution declares nothing) handles
all three, because there is no delegation to typecheck; or **restate existentially** when the theorem
is really an existence claim.

**4. 🥇 The project module must import Mathlib too, or the challenge cannot reproduce its constants.**
This is the one that will cost you the most time, because the error accuses the wrong thing.

Instance resolution depends on what is imported. A project file that imports narrowly — say
`import Mathlib.Data.Nat.Log` — elaborates `b ^ e` on `ℕ` using **core's** `instPowNat`. Your
`Challenge.lean`, which imports Mathlib *by construction*, elaborates the very same source text using
**Mathlib's** `Monoid.toPow`. The two are definitionally equal, so nothing in the project ever notices
— but they are **different terms**, and comparator compares `ConstantInfo`s. It will reject the pair
with something like:

```
Const does not match between challenge and target 'MyProject.bump'
```

which reads like a problem with `bump`'s *proof* or its well-founded recursion. It is neither. Fix it
by making the project module `import Mathlib` (and rebuild — the proofs downstream are typically
unaffected, since the instances are defeq).

Corollary worth internalizing: **this is why the clone-and-bridge pattern accidentally works.** There,
both copies are elaborated under the same full-Mathlib imports, so they agree with each other, and the
project's genuinely-different constant is reached by a *propositional* bridge that papers over the
instance gap. The strong pattern removes the bridge, which means the gap has nowhere to hide. That is
a feature — it is the harness telling you your library and your audit surface disagree about what `^`
means — but it does mean adopting the strong pattern can require touching the project's imports.

**5. ⚠️ The strong pattern breaks when equation-compiler definitions span several project modules.**
Lean **dedups `match_N` auxiliary declarations within a module, but not across modules.** So if your
project defines `u` in `Basic.lean`, `vv` in `Stoll.lean` and `gu` in `General.lean` — each getting its
own matcher — but your *single-file* challenge declares all three together, then `vv` and `gu` silently
**reuse `u.match_1`**. Their `ConstantInfo`s now differ from the project's, and comparator rejects the
pair with a confusing mismatch on a constant you never wrote.

It bites **only** the equation compiler (recursive / pattern-matching defs). Plain definitions, `Prop`s,
set-builders and `sSup`/`limsup` bodies are immune — a challenge whose defs are all plain can span any
number of project modules safely. Likewise, several recursive defs are fine if they all live in **one**
project module.

There is no clean fix. A multi-file challenge would restore the matchers but breaks the "challenge just
imports mathlib, read *one* file" norm that makes the harness legible in the first place; the
alternative is refactoring the project so the recursive definitions share a module. **The honest move
is to leave that one result on the clone-and-bridge pattern and say why in a comment.** A considered
exception beats a clever workaround nobody can review.

**6. Challenge hygiene.**
- ✋ **Never put a sorried or open statement in a challenge.** A challenge may contain only theorems
  the solution actually **proves**. If your project formalizes an open conjecture as a `sorry`d
  statement, keep it out of the harness entirely.
- ✅ **Ship a non-vacuity anchor** where one exists (`foo_witness : factSum {2,3,5} = 2^7`). A
  universally-quantified bound is satisfied by a vacuous theory; an explicit witness or a degenerate
  special case is what convinces a reader the result isn't accidentally empty. Prove these in the
  challenge itself rather than `sorry`ing them where you can — they are part of the audit surface.
- ⚠️ **Don't smuggle in `native_decide` to get an anchor.** It adds `Lean.ofReduceBool`, which is
  outside the whitelist and will fail the run.
- ✅ **Reach for `decide +kernel` before giving up on an anchor.** It discharges by *kernel* reduction
  and adds **no axioms at all**. Crucially, the kernel ignores the irreducibility seal that
  well-founded recursion puts on a definition — which is exactly why plain `decide` gets stuck on a
  WF-defined function while `decide +kernel` sails through. It is often *faster* than `native_decide`
  too (no compile-and-run), thanks to GMP-backed `Nat` literals.

**7. CI-only, and order matters.** `landrun` needs Linux Landlock, so there is no macOS path — expect
no local end-to-end loop. In the workflow, **install `elan` before** building the verifier binaries:
`lean4export` and `comparator` are themselves Lean projects and need `lake`.

Because the real gate is remote, **build yourself a local pre-flight** or you will discover every typo
through a multi-minute CI round-trip. The part worth reproducing is *statement identity*: elaborate the
challenge module and the solution module separately, print each `theorem_names` entry's type plus the
type and value of every constant in that type's transitive closure, and diff the two. Identical output
means comparator's identity check will pass; the rest (kernel replay, nanoda, axioms, sandbox) stays in
CI. Gotcha #4 above was caught this way, before it cost a single failed run.

🦷 **Teeth-test the pre-flight.** The obvious implementation reports a cheerful ✅ when a theorem name is
absent from *both* environments — the two "MISSING" outputs are identical, so they diff clean. Fail
loudly on a missing name instead. **A checker that cannot go red is worse than no checker**, because you
will trust it.

## ✅ Review checklist

Reviewing a harness (yours or someone else's) — in priority order:

1. **Read the challenge's *definitions* against the source paper.** This is the review. Everything
   else is machine-checked. 🎯
2. `enable_nanoda: true`? (Otherwise the one real assurance gain is missing.)
3. Any **definition holes**? → reject; demand real bodies.
4. Does `Solution.lean` re-declare definitions? → the harness is using the weak pattern; the
   certificate is about clones, not the project's genuine constants.
5. Do the `theorem_names` cover the **headline claims**, or a weakened shadow of them?
6. `permitted_axioms` = `propext`, `Quot.sound`, `Classical.choice` and nothing else.
7. Any **non-vacuity anchor**? A bound with no witness may be certifying an empty theory.
8. Is comparator a **required status check**, or a workflow that can silently rot?
9. `formalization.yaml` present, and does it report the uncomfortable things (deliberate `sorry`s,
   unlogged model versions, wall-clock that overstates effort) rather than a tidy fiction?

## Related

Run [`lean-review`](../lean-review/) on the diff as well — comparator does not see a raised
`maxHeartbeats`, and its axiom whitelist is coarser than a `#guard_msgs`-pinned `#print axioms` gate.
The two are complements, not substitutes.
