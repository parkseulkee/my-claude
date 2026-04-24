---
name: explore-plan-code
description: Enforce the Explore → Plan → Code → Commit workflow for ALL code changes. Use whenever the user requests a feature, refactor, bug fix, or any code modification — no matter how small. Separates research from implementation to avoid solving the wrong problem, and breaks work into reviewable commit-sized units. Skip only for pure Q&A / explanation (no code change).
---

# Explore → Plan → Code

Source: https://code.claude.com/docs/en/best-practices — "Explore first, then plan, then code".

Jumping straight to coding produces code that solves the wrong problem. Separate research from execution.

## When this skill applies

**Apply to ALL code changes**, regardless of size. Features, refactors, bug fixes, one-line tweaks, renames, typo fixes — run through the four phases. The depth of each phase scales with the task; the structure does not.

- Trivial diff (typo, log line, rename): Explore and Plan collapse to 1–2 sentences each, but are still written before editing.
- Non-trivial diff: full exploration, written plan with commit breakdown, sign-off before coding.

**Skip only when:**

- Pure Q&A / explanation (no code change)
- User explicitly says "just do it" / "quick fix" (and you've flagged the skipped plan)

## The four phases

### 1. Explore (Plan Mode)

Enter Plan Mode. Read files and answer questions — make no changes.

- Read the directly-implicated files AND the surrounding patterns (how similar features are built in this codebase).
- For broad scopes, **delegate to subagents** so exploration doesn't consume the main context: `"Use subagents to investigate how X works and whether reusable utilities exist."`
- Search for existing functions/utilities that can be reused — avoid proposing new code when suitable implementations exist.
- Output: a clear understanding of what exists, what patterns to follow, and what's missing.

### 2. Plan (still in Plan Mode)

Produce a detailed implementation plan:

- Files to change (with paths) and why
- New functions/modules to add, existing ones to reuse (cite paths)
- Data flow / sequence of operations
- Test strategy (what to verify, how)
- Risks and unknowns
- **Commit breakdown** — split the work into commit-sized units (see below)

### Commit breakdown (required)

Every plan must end with a table listing the commits in order. Present it exactly in this shape:

| #   | Commit title         | Scope (files/functions)   | Why (1 line)                        | Risk | Depends on |
| --- | -------------------- | ------------------------- | ----------------------------------- | ---- | ---------- |
| 1   | `Add X utility`      | `src/utils/x.ts`          | Shared helper reused in commits 2–3 | Low  | —          |
| 2   | `Wire X into Y flow` | `src/y/handler.ts`, tests | Behavioral change — user-visible    | Med  | 1          |
| 3   | `Remove legacy Z`    | `src/legacy/z.ts`         | Cleanup now that Y uses X           | Low  | 2          |

Columns:

- **#** — commit order
- **Commit title** — imperative, matches the repo's commit message style (e.g. `Add X`, `Refactor Y to use Z`)
- **Scope** — which files/functions are touched
- **Why** — one line on the purpose; if a reviewer can't see why this commit exists on its own, merge it with a neighbor
- **Risk** — Low / Med / High (user-visible behavior change, migration, irreversible op → Med+; note any test gaps)
- **Depends on** — previous commit numbers it builds on, or `—`

Rules of thumb:

- One logical change per commit. A refactor + a feature = two commits.
- Each commit should leave the tree in a working, test-passing state. If it can't, say so explicitly and justify.
- Prefer 3–5 small commits over 1 giant commit. Prefer 1 commit over 5 artificial slices.
- Pure mechanical changes (rename, move, format) go in their own commit, separate from behavioral changes — this keeps diffs reviewable.
- For trivial tasks, a single commit is fine — still list it so the scope is explicit.

Keep the plan concise enough to scan, detailed enough to execute. `Ctrl+G` opens the plan in an editor for direct user edits. Get user sign-off before leaving Plan Mode.

**After sign-off:** Immediately write the approved plan to `docs/plans/explore-plan-code/YYYY-MM-DD-<topic>.md` and commit it — before writing any implementation code. This creates a paper trail of the decisions and lets the commit breakdown guide the implementation commits that follow.

### 3. Code (Normal Mode)

- Implement against the plan, not against re-derived intent.
- Write tests (or use existing ones). Run them.
- Verify the plan's success criteria are met. If reality diverges from the plan, pause and update the plan rather than improvising silently.

### 4. Commit

- Commit in the units defined by the plan's commit breakdown — one logical change per commit.
- Descriptive commit message explaining _why_, not just _what_.
- If reality forced you to merge or split commits vs. the plan, state that explicitly before committing.
- Open a PR when appropriate.

## Anti-patterns to avoid

- **Planning in the head, not on paper.** If the plan isn't written down, it doesn't count — it drifts during coding.
- **Exploration without scope.** "Investigate X" with no boundary fills the context. Scope narrowly or use subagents.
- **Skipping verification.** A plausible-looking implementation that doesn't handle edge cases is worse than no implementation. Always include a verification step.
- **Correcting over and over.** After two failed corrections, `/clear` and restart with a better prompt incorporating what was learned.
- **Amending the plan silently.** If the plan is wrong, say so and revise — don't just code past it.

## Interaction with other skills

- If the _requirements themselves_ are unclear (user said "build me a dashboard" with no spec), invoke **brainstorming** first to establish the spec, then apply this skill for implementation.
- For trivial diffs, don't invoke this skill — just make the change.
