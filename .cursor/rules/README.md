# Cursor 工程规则（索引）

规则按**主题**拆到子目录，便于维护；**全部放在子目录下**（避免部分 Cursor 版本在「根目录 `.mdc` + 子目录混放」时不加载子目录规则）。

| 目录 | 内容 |
|------|------|
| [`war3-tstl/`](war3-tstl/) | TSTL → Lua、JASS 调用与回调坑、随机数、全局数组、`udg_TempUnit`、`UnitDamageTarget` |
| [`dzapi/`](dzapi/) | DzAPI UI 帧类型、LoadToc、FDF 崩溃；键盘/sync 以 `ui-frame-types.mdc` §键盘与 `TS/lib/扩展函数/封装函数/04．硬件输入/04．键盘函数.ts` 为准 |
| [`equipment/`](equipment/) | 装备回复 `hot` 字段、`USE_ITEM` 双触发防重 |
| [`stes-ydlocal/`](stes-ydlocal/) | STES 事件、YDLocal 传参/返回值、`YDLocal1Release` |
| [`tooling/`](tooling/) | 调试输出、`print`、音效/漂浮字路径约定 |
| [`agent-shared/`](agent-shared/) | 跨代理入口：约定先看本索引；Codex 等非 Cursor 代理同时参考根目录 `AGENTS.md` |

带 YAML frontmatter 的 `.mdc` 仍可使用 `description`、`globs`、`alwaysApply` 控制是否自动注入上下文。
