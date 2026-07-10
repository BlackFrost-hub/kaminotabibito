# 玩法生产规则

本目录收纳直接定义游戏内容与玩法落地的规则。资源生产和工程工具分别由 `resources/`、`tooling/` 管理。

| 子目录 | 负责内容 | 入口 |
|--------|----------|------|
| `skills/` | 英雄、单位、装备技能，Boss 制作、运行时、测试与验收 | [技能与 Boss 索引](skills/README.md) |
| `equipment/` | 物品、装备、Buff、HOT/DOT、装备风格与评分 | [装备与物品索引](equipment/README.md) |
| `objediting/` | ObjEditing 敌方技能和对象数据制作 | [ObjEditing 索引](objediting/README.md) |
| `story/` | 剧情迁移、对白时长与动作时间线 | [剧情规则](story/README.md) |

涉及多个玩法系统时，分别读取对应入口；不要把 Boss 流程规则当成所有装备、剧情或 ObjEditing 工作的通用规则。
