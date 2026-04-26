# Cursor 工程规则（索引）

规则按主题拆到子目录，便于维护；尽量把规则放在子目录下，而不是把大量细则堆在索引文件里。

## 规则目录

| 目录 | 内容 |
|------|------|
| [`war3-tstl/`](war3-tstl/) | TSTL -> Lua、jass/japi 调用、随机数、全局数组、伤害事件等 War3 运行时坑点 |
| [`dzapi/`](dzapi/) | DzAPI UI、LoadToc、FDF、Frame 类型；**联机 desync / N 槽对称执行 / Timer·sync** 见 [`dzapi/n-slot-ui-symmetric-execution.mdc`](dzapi/n-slot-ui-symmetric-execution.mdc)；**单管理器 + 本地开关 + 关闭重置** 见 [`dzapi/single-manager-local-reset-ui.mdc`](dzapi/single-manager-local-reset-ui.mdc)；**Lua GC / 匿名闭包 / table key / pairs 异步经验** 见 [`dzapi/lua-gc-desync-heuristics.mdc`](dzapi/lua-gc-desync-heuristics.mdc)；**Lua 运行时安全代码模板（句柄保护、pairs 禁用、JASS 回调替换）** 见 [`dzapi/lua-runtime-safety.mdc`](dzapi/lua-runtime-safety.mdc) |
| [`equipment/`](equipment/) | 装备恢复、`hot` 字段、`USE_ITEM` 双触发等约定 |
| [`stes-ydlocal/`](stes-ydlocal/) | STES 事件、YDLocal 传参与返回值、释放约束 |
| [`tooling/`](tooling/) | 调试输出、`print`、音效与封装约定 |
| [`agent-shared/`](agent-shared/) | 跨代理共享规则、全局高优先级规则、Codex / Cursor 共识入口 |

带 YAML frontmatter 的 `.mdc` 文件可通过 `description`、`globs`、`alwaysApply` 控制注入行为。

## 全局高优先级规则

以下规则是全局适用、优先级很高的规则，已单独下沉到 `alwaysApply: true` 文件：

- [`agent-shared/global-engine-rules.mdc`](agent-shared/global-engine-rules.mdc)

其中包括：

- 先看项目根目录 `jass表.txt` 与 `japi表.txt`
- 不混淆 jass / japi / BJ / 本地封装函数
- `require(...)` 必须使用绝对模块路径
- 不把 `globalThis` 当成 jass 全局
- 封装库复用、目录组织、`index` 入口、文件长度与文档补充约定
- STES / YDLocal 的桥接边界与示例入口

## 维护约定

1. README 作为索引使用，尽量不堆放大段具体规则。
2. 全局规则放到 `agent-shared/*.mdc` 并使用 `alwaysApply: true`。
3. 子系统规则放到最相关的子目录中，由更具体的文件承接。
4. 新增项目规则时，在这里补一条入口，保证可发现性。
