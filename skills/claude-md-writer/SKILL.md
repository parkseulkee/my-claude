---
name: claude-md-writer
description: Create or refine a CLAUDE.md file for a project following Anthropic's "Write an effective CLAUDE.md" best practices. Use when the user asks to create, write, generate, draft, improve, prune, or review a CLAUDE.md (or CLAUDE.local.md) file, set up project memory for Claude Code, or add persistent project instructions. Do NOT use for general README/documentation writing.
---

# CLAUDE.md Writer

Produce a CLAUDE.md that gives Claude persistent, high-signal context it can't infer from code. Source: https://code.claude.com/docs/en/best-practices — section "Write an effective CLAUDE.md".

## Core rules

- **Keep it short and human-readable.** Every line must pay for itself. A bloated CLAUDE.md makes Claude ignore instructions.
- **Removal test for every line:** _"Would removing this cause Claude to make mistakes?"_ If no, cut it.
- **Imperative voice, bulleted lists.** No prose tutorials.
- **No required format**, but group by topic (Bash commands, Code style, Testing, Workflow, Gotchas).
- **Emphasize critical rules** with `IMPORTANT:` or `YOU MUST` — sparingly, or emphasis loses meaning.
- **Link, don't duplicate.** Use `@path/to/file.md` imports for shared or longer docs (e.g. `@README.md`, `@docs/git-instructions.md`).

## Include vs. exclude

| Include                                                                      | Exclude                                     |
| ---------------------------------------------------------------------------- | ------------------------------------------- |
| Bash commands Claude can't guess (custom scripts, non-standard test runners) | Anything Claude can figure out from code    |
| Code style rules that differ from language defaults                          | Standard language conventions               |
| Testing instructions / preferred test runners                                | Detailed API docs (link instead)            |
| Repo etiquette (branch naming, PR/commit conventions)                        | Info that changes frequently                |
| Architectural decisions specific to the project                              | Long explanations or tutorials              |
| Dev-env quirks (required env vars, setup gotchas)                            | File-by-file codebase descriptions          |
| Common gotchas / non-obvious behaviors                                       | Self-evident practices ("write clean code") |

## Workflow

1. **Check for existing CLAUDE.md.** If present, read it and propose edits rather than rewriting wholesale.
2. **Recommend `/init` first** if the project has none and is fresh — it auto-detects build systems, test frameworks, and patterns. This skill then refines the output.
3. **Inspect the repo** before asking the user. Discover what you can:
   - `package.json` / `pyproject.toml` / `Cargo.toml` / `go.mod` — build + test commands
   - `.github/`, `CONTRIBUTING.md` — PR/branch conventions
   - `README.md` — project purpose (link to it, don't duplicate)
   - Lint/format configs — style that differs from defaults
4. **Ask the user only for non-discoverable context:**
   - Common gotchas / tribal knowledge
   - Required env vars or local setup quirks
   - Workflow preferences ("run single tests, not the full suite")
   - Scope: global (`~/.claude/CLAUDE.md`), team (`./CLAUDE.md`), or personal (`./CLAUDE.local.md`)
5. **Draft** using the template below. Aim for under ~40 lines for most projects.
6. **Prune pass.** Re-read the draft and delete every line that fails the removal test.
7. **Write the file.** If `CLAUDE.local.md`, remind the user to add it to `.gitignore`.

## Template

```markdown
# Project: <name> — one-line purpose

See @README.md for overview.

# Bash commands

- `<cmd>`: <what it does — only if non-obvious>

# Code style

- <rule that differs from language default>

# Testing

- <preferred runner / flags>
- Prefer running single tests, not the whole suite

# Workflow

- Typecheck after a series of edits
- Branch naming: feature/<ticket>-<slug>

# Gotchas

- <non-obvious behavior, required env var, etc.>
```

## File locations

- `~/.claude/CLAUDE.md` — applies to all sessions (global/personal)
- `./CLAUDE.md` — project root, checked into git, shared with team
- `./CLAUDE.local.md` — personal project notes; must be gitignored
- Parent/child directories — auto-loaded in monorepos; child files load on demand
- `@path/to/file.md` — import syntax for shared sub-docs

## Prefer a skill when

The context only applies to _some_ tasks (domain workflows, specialized procedures). CLAUDE.md loads every session; skills load on demand. Recommend a skill under `.claude/skills/` instead of growing CLAUDE.md.

## Red flags when reviewing an existing CLAUDE.md

- Over ~60 lines without strong justification → prune
- Repeats things obvious from code → cut
- File-by-file codebase tour → replace with one architectural note
- Standard conventions ("use meaningful names", "write tests") → cut
- Frequently changing info (current sprint, TODOs) → move elsewhere
- Same rule stated multiple ways → consolidate
- Claude keeps violating a rule that's present → file is too long; prune harder
