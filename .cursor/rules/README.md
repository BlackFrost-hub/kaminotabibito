# Cursor 工程规则（索引）

规则按主题拆到子目录，便于维护。

## 规则目录

| 目录 | 内容 |
|------|------|
| [`war3-tstl/`](war3-tstl/) | War3 + TSTL 编译坑：jass/japi 调用、回调注册、随机数、全局数组、伤害事件等 |
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

说明：

- 近期高优先级、跨子系统反复出现的 TSTL / desync / JASS-Dz 关键坑，已收敛进 `GLOBAL_AGENT_PROMPT.mdc`，不再单独维护一份 `tstl-recent/` 增量规则目录。
## 调试输出约定

- 默认统一使用 `TS/lib/扩展函数/自定义扩展函数/03．调试输出.ts`
- 需要强制输出时优先使用 `debugLogForce`
- 需要模块级开关调试时使用 `setDebug` 与 `debugLog`
- 不要在普通业务代码、测试代码里继续把 `DisplayTimedTextToPlayer` 当作默认调试输出手段

## JASS 调用约定

- 对 `require("jass.common")`、`require("jass.japi")` 得到的模块表，默认不要直接写 `jass.Xxx(...)`、`japi.Xxx(...)`
- 统一先绑定局部函数别名，再调用别名，例如 `const PauseUnit = jass.PauseUnit as ...`，随后调用 `PauseUnit(...)`
- 这样做是为了避免 TSTL 把点调用错误生成为 `jass:Xxx(...)` / `japi:Xxx(...)`
- 这条规则同样适用于测试文件、临时代码、技能文件，不允许因为“只是测试”就省略
