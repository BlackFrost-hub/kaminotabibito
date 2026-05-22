---
name: syzl-project-rules
description: Route work in the syzl repository through its current project-specific engineering rules. Use when working anywhere in this repo. Read `.cursor/rules/README.md` first, then `.cursor/rules/GLOBAL_AGENT_PROMPT.mdc`, then only the most specific subsystem rules needed for the files being changed.
---

# Syzl Project Rules

## Purpose

Use this skill to route into the repo rule system before making changes.

Do not use this skill as a second full copy of the repo rules.

Authoritative rule sources are:

1. `.cursor/rules/README.md`
2. `.cursor/rules/GLOBAL_AGENT_PROMPT.mdc`
3. the most specific subsystem rule files for the code being changed

## First Pass

0. Read the project-root `jass表.txt` and `japi表.txt` first when the task touches engine APIs, JASS, DzAPI, BJ wrappers, or Lua/JASS interop.
1. Read `.cursor/rules/README.md`.
2. Read `.cursor/rules/GLOBAL_AGENT_PROMPT.mdc`.
3. Read the most relevant rule files under `.cursor/rules/` for the files or subsystem being touched.
4. Prefer the more specific rule when multiple rules apply.
5. Fall back to `.cursor/rules/agent-shared/global-engine-rules.mdc` when no subsystem rule is more specific.
6. Before rewriting Chinese-heavy files or touching TSTL callback / `@noSelfInFile` issues, read `.cursor/rules/tooling/encoding-and-patch-safety.mdc`.

## Rule Routing

- DzAPI, task UI, FDF, LoadToc, frame callbacks, hotkeys, `GetLocalPlayer`, `sync=true`, timers, desync, N-slot UI:
  Read `.cursor/rules/dzapi/n-slot-ui-symmetric-execution.mdc` first, then `ui-frame-types.mdc`, `loadtoc-ui.mdc`, or `fdf-crash.mdc` as needed.
- General engine boundaries, `require(...)`, jass/japi/BJ separation, `globalThis`, event-center usage:
  Read `.cursor/rules/agent-shared/global-engine-rules.mdc`.
- TSTL, Lua/JASS runtime pitfalls, random seed, arrays, damage, `self/nil` drift, callback shape, or `@noSelfInFile`:
  Read `.cursor/rules/agent-shared/tstl-hard-rules.mdc` and then `.cursor/rules/war3-tstl/*` as needed.
- Equipment data, `hot`, `USE_ITEM`, equipment triggers:
  Read `.cursor/rules/equipment/*`.
- STES, YDLocal return values, or memory-release rules:
  Read `.cursor/rules/stes-ydlocal/*`.
- Debug output, `print`, sound, encoding, or patch safety:
  Read `.cursor/rules/tooling/*`.

## Routing Notes

- Keep this skill short. High-priority engine, TSTL, desync, callback, pcall, tooltip, no-self, and encoding rules belong in `GLOBAL_AGENT_PROMPT.mdc`.
- Do not duplicate long rule bodies here. This file should tell the agent where to look, not restate the entire repo contract.
- Re-open the specific rule file before changing a high-risk area instead of relying on memory.
- This repo may not always have a root `AGENTS.md`; the actual rule entry remains `.cursor/rules/`.

## Working Style

- Keep explanations short and repo-specific.
- Cite concrete rule files when making recommendations.
- If rules seem to conflict, prefer the file closest to the code being changed.
- Run `npm run build` after actual code changes are complete, and report the result.
- Use `apply_patch` for manual edits; avoid whole-file rewrites unless truly necessary.
- Before rewriting Chinese-heavy files or fixing TSTL callback/no-self issues, read `.cursor/rules/tooling/encoding-and-patch-safety.mdc`.
- Prefer local patch edits over whole-file rewrites; verify generated `src/**/*.lua` only after a successful build.
- Do not treat terminal mojibake as proof that a source file is already damaged. Distinguish display/code-page problems from real byte corruption before rewriting Chinese-heavy files.
- Do not change `fix-lua-for-pack.js` just to work around TSTL; prefer fixing the TypeScript source shape.
