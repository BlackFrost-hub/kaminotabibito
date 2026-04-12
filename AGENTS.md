# Agent Guide

This repository keeps its project-specific engineering rules in `.cursor/rules/`.

For Codex and other non-Cursor agents:

1. Start with `.cursor/rules/README.md`.
2. Treat `.cursor/rules/` as the project rule source of truth for domain conventions, engine pitfalls, and tooling constraints.
3. Before editing code, read the rule files that match the area you are touching.
4. When multiple rules apply, prefer the more specific rule for the subsystem you are changing.

Current rule areas include:

- `war3-tstl/`: TSTL, Lua, JASS, callback, and random-number pitfalls.
- `dzapi/`: DzAPI UI frame usage, sync behavior, and FDF/UI pitfalls.
- `equipment/`: equipment-related data and trigger conventions.
- `stes-ydlocal/`: STES and YDLocal usage constraints.
- `tooling/`: debug output, sound, and encapsulation conventions.

If you add new project rules, register them in `.cursor/rules/README.md` so every agent can discover them quickly.
