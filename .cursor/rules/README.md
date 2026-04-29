# Cursor 工程规则（索引）

规则按主题拆到子目录，便于维护。

## 规则目录

| 目录 | 内容 |
|------|------|
| [`war3-tstl/`](war3-tstl/) | War3 + TSTL 编译坑：jass/japi 调用、回调注册、随机数、全局数组、伤害事件等 |
| [`tstl-recent/`](tstl-recent/) | 近期已复现的 TSTL 增量坑（no-self 参数右移、核心依赖环、缺失 API 中断初始化、机制混用） |
| [`dzapi/`](dzapi/) | DzAPI UI Frame 类型、联机 desync / 对称执行 / N 槽、Lua GC 安全、运行时安全代码 |
| [`equipment/`](equipment/) | 装备恢复、hot 字段、USE_ITEM 双触发等约定 |
| [`stes-ydlocal/`](stes-ydlocal/) | STES 事件、YDLocal 传参与返回值、释放约束 |
| [`tooling/`](tooling/) | 调试输出、音效与封装约定、编码与补丁安全 |
| [`agent-shared/`](agent-shared/) | 跨代理共享规则、全局高优先级规则 |

带 YAML frontmatter 的 `.mdc` 文件可通过 `description`、`globs`、`alwaysApply` 控制注入行为。纯 `.md` 文件为参考文档，不自动注入。

## 全局高优先级规则

- [`agent-shared/global-engine-rules.mdc`](agent-shared/global-engine-rules.mdc) — `alwaysApply: true`，包含 jass/japi/BJ 边界、require 路径、事件中心、安全检查等
- [`agent-shared/中文命名.mdc`](agent-shared/中文命名.mdc) — `alwaysApply: true`，新代码中文命名偏好

## 维护约定

1. README 作为索引，不堆放大段具体规则。
2. 全局规则放到 `agent-shared/*.mdc` 并使用 `alwaysApply: true`。
3. 子系统规则放到最相关的子目录中。
4. 新增项目规则时，在这里补一条入口。