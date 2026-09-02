# ObjEditing 规则

本目录管理对象数据与 ObjEditing 业务规则。

| 场景 | 先读 |
|------|------|
| 制作敌方、Boss 或单位技能的对象数据 | [敌方技能制作规则](敌方技能制作规则.mdc) |
| 分配新物体 ID / 给英雄、Boss 定 Rawcode / 改单位 ID | [物体ID分配与大小写冲突](物体ID分配与大小写冲突.mdc) |

如果任务同时包含 TS 技能逻辑，继续读取 [技能与 Boss 索引](../skills/README.md)；如果是装备对象数据，继续读取 [装备与物品索引](../equipment/README.md)。

Hero Boss 对象数据位于 `objediting/Boss/HeroBoss/`，必须按 `01-MainlineBoss`、`02-ChallengeHiddenBoss`、`03-OtherworldBoss` 分类，并登记到分类入口；根 `HeroBoss.lua` 只加载分类入口，不直接堆放单个 Boss。

## 运行 ObjEditing

- VSCode / Cursor 命令面板：按 `Ctrl+Shift+P`，运行 `Pack Objects`。
- Warcraft 插件命令 ID：`extension.warcraft.pack.object`。不要手动拆解验证。
- 项目物编代码入口：`objediting/main.lua`。
- 当前编辑器优先使用：`C:\Users\Administrator\.cursor\extensions\dencer.warcraft-vscode-0.3.5\bin\ObjEditing.exe`。
- 本机存在其他 `ObjEditing.exe` 副本时，默认不要混用；除非当前插件版本不可用或用户明确指定，否则以上述 `.cursor\extensions` 路径为准。
