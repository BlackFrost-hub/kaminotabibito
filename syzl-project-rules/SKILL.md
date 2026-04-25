---
name: syzl-project-rules
description: Route work in the syzl repository through its project-specific engineering rules. Use when working anywhere in this repo, especially for TypeScript, Lua, JASS, DzAPI UI, task UI, shared single-UI managers, N-slot symmetric UI, equipment, STES/YDLocal, or other areas covered by `.cursor/rules/`.
---

# Syzl Project Rules

## Overview

Use this skill to onboard into the repo's rule system before making changes. Read the repo rules in the right order, route to the most specific subsystem rules, and treat `.cursor/rules/` as the authoritative source instead of re-explaining local conventions from memory.

## First Pass

0. Read the project-root `jass表.txt` and `japi表.txt` first when the task touches engine APIs, JASS, DzAPI, BJ wrappers, or Lua/JASS interop.
1. Read `.cursor/rules/README.md`.
2. Read `AGENTS.md`.
3. Read the most relevant rule files under `.cursor/rules/` for the files or subsystem being touched.
4. Prefer the more specific rule when multiple rules apply.
5. Fall back to `.cursor/rules/agent-shared/global-engine-rules.mdc` when no subsystem rule is more specific.

## Rule Routing

- DzAPI, task UI, FDF, LoadToc, frame callbacks, hotkeys, `GetLocalPlayer`, `sync=true`, Timer, desync, N-slot UI:
  Read `.cursor/rules/dzapi/n-slot-ui-symmetric-execution.mdc` first, then `ui-frame-types.mdc`, `loadtoc-ui.mdc`, or `fdf-crash.mdc` as needed.
- General engine boundaries, `require(...)`, jass/japi/BJ separation, `globalThis`, event-center usage:
  Read `.cursor/rules/agent-shared/global-engine-rules.mdc`.
- TSTL, Lua/JASS runtime pitfalls, random seed, arrays, damage, or safety checks:
  Read `.cursor/rules/war3-tstl/*`.
- Equipment data, `hot`, `USE_ITEM`, equipment triggers:
  Read `.cursor/rules/equipment/*`.
- STES, YDLocal return values, or memory-release rules:
  Read `.cursor/rules/stes-ydlocal/*`.
- Debug output, `print`, sound, or encapsulation:
  Read `.cursor/rules/tooling/*`.

## Non-Negotiables

- Treat `.cursor/rules/` as the source of truth. Do not duplicate detailed rules into code comments or new docs unless the user asks.
- Re-open the specific rule file before changing a high-risk area instead of relying on memory.
- Check the project-root `jass表.txt` and `japi表.txt` before deciding whether an API is `jass` or `japi`.
- Do not blur `jass`, `japi`, BJ wrappers, and local helper libraries.
- Do not treat BJ functions as `jass` or `japi` functions, and do not mix `jass`, `japi`, and BJ semantics with each other.
- Use absolute `require(...)` paths.
- Do not treat `globalThis` as a replacement for JASS globals.
- Do not make local function libraries pretend to be `jass` or `japi`, and do not make engine APIs depend on local helper implementations.
- Route new player-unit event wiring through the repo event center unless a documented exception applies.

## DzAPI Red Lines

- Use N-slot thinking by default for complex task UI and other risky Dz panels: symmetric creation/registration first, local show/input gating last.
- Keep sync-sensitive code on all clients with the same order, count, and branching.
- Keep local-only UI work inside `GetLocalPlayer()` branches.
- When `sync=true` is involved, re-check `n-slot-ui-symmetric-execution.mdc` before editing.
- Treat `ui-frame-types.mdc` as the API/layout reference and `n-slot-ui-symmetric-execution.mdc` as the multiplayer-semantics reference.

## Shared UI Architecture

When the task is about Warcraft III multiplayer UI architecture, classify the topology before changing code.

### Global Single-UI Manager

Use when:

- Each client owns one logical UI tree
- Interaction is mainly local visual behavior
- Open/close, tab switch, expand/collapse, and paging are local presentation

Bias:

- One manager
- One frame tree
- Mouse events usually `sync=false`
- Keyboard may be local only if the platform path is proven stable
- Mouse and keyboard must converge into the same downstream local functions
- Prefer only visual/idempotent operations on already-existing frames

### N-Slot Symmetric UI

Use when:

- Each client must hold slot UI for all players
- Shared slot state must stay symmetric
- Only final visibility differs per local player

Bias:

- One manager, not one manager instance per player
- Create slot frames symmetrically
- Keep creation, registration, timers, and shared state symmetric
- Only final visibility and explicitly local feedback stay local

## Local False Chain Rules

Inside a local `sync=false` mouse/keyboard/UI chain, prefer only:

- `DzFrameShow`
- `DzFrameSetText`
- `DzFrameSetTexture`
- `DzFrameSetPoint`
- `DzFrameSetSize`
- Switching prebuilt pages/variants by show/hide
- Local click sound restricted to the local player

Do not put these into the local `false` chain unless the whole subsystem is intentionally symmetric:

- `DzSyncData` / `DzSyncDataImmediately`
- Desync probes that create handles locally
- `CreateItem` / `RemoveItem` for diagnostics
- Runtime frame creation triggered by local interaction
- Runtime event registration triggered by local interaction
- Timers started only from local UI interaction
- Bare `SoundUI_ClickPlay()` / `StartSound()` that reaches all clients

## Sound Rule

Local UI sound must be explicitly local.

Bad:

```ts
SoundUI_ClickPlay();
```

Good:

```ts
const localPlayer = GetLocalPlayer();
SoundUI_ClickPlay(undefined, localPlayer);
```

Best:

- Cache `localPlayer` once in the UI manager
- Reuse one `playLocalClickSound()` helper in buttons, hotkeys, and row clicks

## Working Style

- Keep explanations short and repo-specific.
- Cite concrete rule files when making recommendations.
- If rules seem to conflict, prefer the file closest to the code being changed.
- Run `npm run build` after actual code changes are complete, and report the result.
