# Design Principles

## Table of Contents
- [Anti-Pattern: "This Is Too Simple"](#anti-pattern)
- [Scoping and Decomposition](#scoping)
- [Design for Isolation](#isolation)
- [Working in Existing Codebases](#existing-codebases)

---

## Anti-Pattern: "This Is Too Simple To Need A Design" {#anti-pattern}

Every project goes through this process. A todo list, a single-function utility, a config change — all of them. "Simple" projects are where unexamined assumptions cause the most wasted work.

The design can be short (a few sentences for truly simple projects), but you MUST present it and get approval before writing any code.

---

## Scoping and Decomposition {#scoping}

Before asking clarifying questions, assess scope:

- If the request describes multiple independent subsystems (e.g., "build a platform with chat, file storage, billing, and analytics"), flag this immediately.
- Don't spend questions refining details of a project that needs to be decomposed first.
- Help the user decompose into sub-projects: what are the independent pieces, how do they relate, what order should they be built?
- Then brainstorm the first sub-project through the normal flow. Each sub-project gets its own spec → plan → implementation cycle.

---

## Design for Isolation {#isolation}

Break the system into smaller units where each:
- Has one clear purpose
- Communicates through well-defined interfaces
- Can be understood and tested independently

**The test for good boundaries:**
1. Can someone understand what a unit does without reading its internals?
2. Can you change the internals without breaking consumers?
3. For each unit: what does it do, how do you use it, what does it depend on?

If not, the boundaries need work. Smaller, well-bounded units are also easier to work with — reasoning is more reliable when code fits in context at once. When a file grows large, that's often a signal it's doing too much.

---

## Working in Existing Codebases {#existing-codebases}

- Explore the current structure before proposing changes.
- Follow existing patterns — don't introduce new conventions without reason.
- Where existing code has problems that affect the work (e.g., a file that's grown too large, unclear boundaries, tangled responsibilities), include targeted improvements as part of the design.
- Don't propose unrelated refactoring. Stay focused on what serves the current goal.
