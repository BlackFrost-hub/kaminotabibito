# 核心规则

本目录存放跨越所有业务模块的工程约束。它回答“所有代码都必须遵守什么”，不收纳某个玩法、资源或工具的局部流程。

## 全局正文

| 文件 | 负责内容 |
|------|----------|
| [global-engine-rules.mdc](global-engine-rules.mdc) | JASS、JAPI、BJ、require、事件中心与 API 边界 |
| [tstl-hard-rules.mdc](tstl-hard-rules.mdc) | TSTL 调用形态、this、self/nil 与生成 Lua 验收 |
| [中文命名.mdc](中文命名.mdc) | 新代码的中文命名偏好与例外 |

## 查询与维护

| 场景 | 入口 |
|------|------|
| 查现有封装、事件入口、数据表或运行时 API | [项目通用函数与 API 经验](项目通用函数与API经验.md) |
| 维护规则结构、索引或 Codex 技能 | [跨智能体规则桥接](codex-reference.mdc) |

## 继续路由

| 专项 | 进入 |
|------|------|
| DzAPI、联机 UI、回调与 desync | [DzAPI 规则](../engine/dzapi/README.md) |
| Warcraft/TSTL 语义补充 | [TSTL 补充规则](../engine/tstl/README.md) |
| STES 与 YDLocal | [桥接规则](../engine/bridges/README.md) |
| 中文文件安全修改 | [编码与补丁安全](../tooling/patch/encoding-and-patch-safety.mdc) |

`global-engine-rules.mdc`、`tstl-hard-rules.mdc`、`中文命名.mdc` 使用 `alwaysApply: true`；其余文件按任务读取。
