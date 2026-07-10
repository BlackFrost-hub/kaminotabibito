---
name: syzl-project-rules
description: Route all work in the syzl Warcraft 3 TypeScriptToLua repository through its project-specific rules. Use whenever Codex edits, reviews, diagnoses, builds, or produces gameplay, engine, resource, tooling, Boss, equipment, UI, audio, voice, ObjEditing, or story content in this repository.
---

# Syzl Project Rules

Use this skill as a router into the repository rules. Do not copy full rule bodies into this skill.

## Start Here

1. Read `.cursor/rules/README.md`.
2. Read `.cursor/rules/GLOBAL_AGENT_PROMPT.mdc`.
3. Read only the most specific category and rule files needed for the task.
4. Prefer user/system instructions, then the rule closest to the files being changed.

When engine APIs, JASS, JAPI, BJ, DzAPI, or Lua/JASS interop are involved, also check the project-root `jass表.txt` and `japi表.txt` as runtime truth.

## Category Routing

- Cross-project constraints, JASS/JAPI/BJ boundaries, require paths, TSTL hard rules, Chinese naming, existing APIs:
  Read `.cursor/rules/core/README.md`.
- DzAPI UI, FDF/Frame, GetLocalPlayer, desync, callback lifecycle, Warcraft/TSTL details, STES or YDLocal:
  Read `.cursor/rules/engine/README.md`, then its `dzapi/`, `tstl/`, or `bridges/` entry.
- Skills, Bosses, equipment, Buffs, ObjEditing, tests, rewards, or story content:
  Read `.cursor/rules/gameplay/README.md`, then the relevant subsystem entry.
- SFX, Voice, external MIX packs, models, textures, effects, temporary assets, or import paths:
  Read `.cursor/rules/resources/README.md`.
- Build behavior, Run Map boundaries, packaging diagnostics, encoding, or patch safety:
  Read `.cursor/rules/tooling/README.md`.

## High-Risk Checks

- Before editing Chinese-heavy TS/MD/FDF or diagnosing mojibake, read `.cursor/rules/tooling/patch/encoding-and-patch-safety.mdc` and use small patches.
- After sensitive TSTL callback, bridge, event, UI, or no-self changes, run the build and inspect only the relevant generated Lua call shape.
- Treat `jass表.txt`, `japi表.txt`, and existing wrappers as API truth; do not invent engine natives or bypass established encapsulation.
- Ordinary code integration does not authorize manual map packaging. Run `npm run build` when appropriate; let the user use Warcraft VSCode `Run Map` unless they explicitly request packing or packaging diagnosis.
- Voice and SFX follow different workflows. Keep unconfirmed generated assets in `audio_temp`; only confirmed external Voice entries belong in the voice-pack manifest.

## Rule Maintenance

- Keep `.cursor/rules/README.md` as the only top-level navigation page.
- Classify rules under `core / engine / gameplay / resources / tooling`.
- Keep one authoritative body per topic; README files and this skill only route.
- When moving a rule, update category indexes, relative links, source comments, and this skill.
- Do not add links to planned files that do not exist.

## Working Style

- Read first, patch the smallest relevant surface, and preserve unrelated dirty-worktree changes.
- Use `apply_patch` for manual edits; avoid whole-file rewrites for localized changes.
- Report what was changed and what was actually verified.
