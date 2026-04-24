---
name: brainstorming
description: "Use BEFORE any creative or implementation work — creating features, building components, adding functionality, or modifying behavior. Explores user intent, requirements, and design before any code is written. Trigger on any request to build, create, design, add, or change functionality."
---

# Brainstorming Ideas Into Designs

Turn ideas into fully formed designs through collaborative dialogue. Explore before implementing.

<HARD-GATE>
Do NOT write code, scaffold projects, invoke implementation skills, or take any implementation action until you have presented a design and the user has explicitly approved it. This applies to ALL projects — no exceptions for "simple" work.
</HARD-GATE>

## Checklist

Create a task for each item and complete in order:

1. **Explore project context** — check files, docs, recent commits
2. **Offer visual companion** (if visual questions ahead) — its own message, nothing else
3. **Ask clarifying questions** — one at a time: purpose, constraints, success criteria
4. **Propose 2-3 approaches** — with trade-offs and a clear recommendation
5. **Present design sections** — get approval after each section before continuing
6. **Write design doc** — `docs/plans/brainstorming/YYYY-MM-DD-<topic>.md`, commit it
7. **Spec self-review** — fix placeholders, contradictions, ambiguity, scope issues inline
8. **User reviews spec** — ask user to review; wait for approval before continuing
9. **Invoke explore-plan-code** — transition to implementation planning

**Terminal state is explore-plan-code.** Never invoke any other implementation skill.

## Process

**Scope check first:** Before asking clarifying questions, assess scope. If the request spans multiple independent subsystems, flag it and help decompose into sub-projects. Each sub-project gets its own spec → plan → implementation cycle.

**Clarifying questions:** One per message. Prefer multiple-choice. Focus on purpose, constraints, and success criteria. Only move forward once you understand what you're building.

**Approaches:** Propose 2-3 with trade-offs. Lead with your recommendation and the reasoning behind it.

**Design presentation:** Scale each section to its complexity (a few sentences for simple, up to 200–300 words for nuanced). Cover: architecture, components, data flow, error handling, testing. Ask after each section if it looks right. Revise before advancing.

**Design for isolation:** Each unit should have one clear purpose, communicate through well-defined interfaces, and be understandable and testable independently. If you can't explain what a unit does without reading its internals, the boundaries need work.

**Existing codebases:** Explore before proposing. Follow existing patterns. Include targeted improvements for code in your path — not unrelated refactoring.

For detailed design principles and anti-patterns → `references/design-principles.md`

## After the Design

**Write spec** to `docs/plans/brainstorming/YYYY-MM-DD-<topic>.md` and commit to git.

**Self-review** (fix inline — no need to re-review):

- Placeholders or TBDs? Fill them in.
- Internal contradictions? Resolve them.
- Scope: focused enough for a single implementation plan?
- Ambiguity: could any requirement be interpreted two ways? Pick one, make it explicit.

For dispatching a subagent spec reviewer → `references/spec-reviewer.md`

**User review gate:** After passing self-review, ask:

> "Spec written and committed to `<path>`. Please review it and let me know if you'd like any changes before we start the implementation plan."

Wait for the user's response. Make changes if requested, re-run self-review. Only invoke explore-plan-code once the user approves.

## Key Principles

- **One question at a time** — don't overwhelm
- **Multiple choice preferred** — easier to answer than open-ended
- **YAGNI ruthlessly** — remove unnecessary features from every design
- **Always explore alternatives** — 2-3 approaches before settling
- **Incremental validation** — present, get approval, then advance

## Visual Companion

A browser-based tool for mockups, diagrams, and visual options. A tool, not a mode — decide per question, not per session.

**Offer once** when you anticipate visual questions (its own message, no other content):

> "Some of what we're working on might be easier to explain visually. I can show mockups, diagrams, and comparisons in a web browser as we go. This is still new and can be token-intensive. Want to try it? (Requires opening a local URL)"

**Per-question test:** Would the user understand this better by _seeing_ it than _reading_ it?

- **Browser:** mockups, wireframes, layout comparisons, architecture diagrams
- **Terminal:** requirements questions, conceptual choices, tradeoff lists, clarifying questions

If the user accepts → read `references/visual-companion.md` before proceeding.
