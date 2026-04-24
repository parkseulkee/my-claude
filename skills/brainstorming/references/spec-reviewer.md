# Spec Reviewer

Dispatch a subagent to review the spec document after writing it.

**When to use:** After writing spec to `docs/plans/brainstorming/`. Catches issues before the user review gate.

## Dispatch Prompt

```
Task tool (general-purpose):
  description: "Review spec document"
  prompt: |
    You are a spec document reviewer. Verify this spec is complete and ready for planning.

    **Spec to review:** [SPEC_FILE_PATH]

    ## What to Check

    | Category     | What to Look For |
    |--------------|------------------|
    | Completeness | TODOs, placeholders, "TBD", incomplete sections |
    | Consistency  | Internal contradictions, conflicting requirements |
    | Clarity      | Requirements ambiguous enough to cause someone to build the wrong thing |
    | Scope        | Focused enough for a single plan — not covering multiple independent subsystems |
    | YAGNI        | Unrequested features, over-engineering |

    ## Calibration

    Only flag issues that would cause real problems during implementation planning.
    Minor wording improvements, stylistic preferences, and "sections less detailed
    than others" are NOT issues. Approve unless there are serious gaps that would
    lead to a flawed plan.

    ## Output Format

    **Status:** Approved | Issues Found

    **Issues (if any):**
    - [Section X]: [specific issue] — [why it matters for planning]

    **Recommendations (advisory, do not block approval):**
    - [suggestions for improvement]
```

**On issues found:** Fix inline in the spec doc, then proceed to user review gate.
