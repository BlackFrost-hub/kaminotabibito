# Syzl 工程规则导航

> 本页是 `.cursor/rules/` 的唯一总入口。先按任务选择分类，再读取最具体的正文；索引只负责路由，不复制规则内容。

## 规则结构

| 分类 | 负责内容 | 入口 |
|------|----------|------|
| `core/` | 全仓库通用约束、JASS/JAPI/BJ 边界、TSTL 硬规则、中文命名、项目 API 速查 | [核心规则](core/README.md) |
| `engine/` | Warcraft 运行时专项：DzAPI UI、联机同步、TSTL 补充、STES/YDLocal 桥接 | [引擎规则](engine/README.md) |
| `gameplay/` | 玩法生产：技能与 Boss、装备与 Buff、ObjEditing、剧情任务 | [玩法规则](gameplay/README.md) |
| `resources/` | 资源生产：Boss SFX、Voice、外置 MIX、模型、贴图、特效 | [资源规则](resources/README.md) |
| `tooling/` | 工程操作：构建、Run Map/打包边界、编码与安全补丁 | [工具规则](tooling/README.md) |

## 默认阅读顺序

1. 从本页定位任务分类。
2. 阅读 [项目规则总纲](GLOBAL_AGENT_PROMPT.mdc)。
3. 确认 [核心规则](core/README.md) 中与任务相关的全局约束。
4. 进入最具体的分类 README，只读取当前改动真正涉及的规则。
5. 规则冲突时，用户/系统指令优先，其次是离目标文件更近、适用范围更具体的规则。

## 按任务快速进入

| 任务 | 先读 |
|------|------|
| TypeScript、Lua、JASS、JAPI、BJ、require、事件中心 | [核心规则](core/README.md) |
| self/nil、回调调用形态、生成 Lua、随机数、JASS 数组 | [引擎规则](engine/README.md) |
| DzAPI、FDF、Frame、GetLocalPlayer、联机 UI 或 desync | [DzAPI 索引](engine/dzapi/README.md) |
| STES、YDLocal、JASS 与 Lua 传参/返回值 | [桥接规则](engine/bridges/README.md) |
| Boss、英雄、单位或装备技能，技能测试 | [技能与 Boss 索引](gameplay/skills/README.md) |
| 物品、装备、Buff、HOT/DOT、评分 | [装备与物品索引](gameplay/equipment/README.md) |
| ObjEditing 敌方技能或对象数据 | [ObjEditing 索引](gameplay/objediting/README.md) |
| 剧情迁移、对白时长、动作挂点 | [剧情规则](gameplay/story/README.md) |
| 音效、配音、MIX、模型、贴图、特效 | [资源规则](resources/README.md) |
| 构建、打包、中文文件安全修改 | [工具规则](tooling/README.md) |
| 维护规则目录或同步 Codex 技能 | [规则系统维护](core/codex-reference.mdc) |

## 自动注入与参考文档

- 带 YAML frontmatter 的 `.mdc` 可通过 `description`、`globs`、`alwaysApply` 控制注入。
- 纯 `.md` 是按需读取的参考文档，不自动注入。
- `core/global-engine-rules.mdc`、`core/tstl-hard-rules.mdc`、`core/中文命名.mdc` 是当前全局自动规则。

## 维护约定

1. 一个主题只保留一个正文真源；总纲、README 和技能只做路由。
2. 新规则放进最具体的分类，不在根目录新增散文件。
3. 移动或重命名规则时，同步更新 README、源码注释、交叉链接和 `syzl-project-rules/SKILL.md`。
4. 不创建指向不存在文件的“预留链接”；规则尚未拆出时，链接到当前真实正文。
5. 普通代码接入默认只做必要构建验证，不自动手动打包地图；打包边界以 `tooling/build/` 为准。
