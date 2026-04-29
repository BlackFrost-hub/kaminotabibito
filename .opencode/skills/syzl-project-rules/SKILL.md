---
name: syzl-project-rules
description: Route work in the syzl repository through its project-specific engineering rules stored in `.cursor/rules/`. Use this skill for any work in this repo, especially for TypeScript, Lua, JASS, DzAPI UI, task UI, shared single-UI managers, N-slot symmetric UI, equipment, STES/YDLocal.
---

# Syzl Project Rules

This skill loads the project's engineering rules from `.cursor/rules/` to ensure consistent behavior across all AI agents.

## Usage

When working in this repository:
1. Read `.cursor/rules/README.md` first
2. Read `AGENTS.md` for agent-specific guidance
3. Consult the most relevant rule files under `.cursor/rules/` for your task

## Key Rules

- `.cursor/rules/` is the source of truth for this project
- All callbacks entering JASS engine must be named functions (no anonymous closures)
- Use absolute `require(...)` paths
- Check `jass表.txt` and `japi表.txt` before assuming an engine API exists
- For multiplayer UI, use N-slot symmetric thinking by default
