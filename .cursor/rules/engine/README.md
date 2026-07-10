# Warcraft 引擎规则

本目录收纳 Warcraft 运行时与 TypeScriptToLua 专项规则。全局边界仍以 [核心规则](../core/README.md) 为准。

| 子目录 | 负责内容 | 入口 |
|--------|----------|------|
| `dzapi/` | Frame/FDF、GetLocalPlayer、联机对称执行、回调 GC、JAPI UnitState | [DzAPI 索引](dzapi/README.md) |
| `tstl/` | JASS 全局数组、随机数与 Warcraft/Lua 语义补充 | [TSTL 补充索引](tstl/README.md) |
| `bridges/` | STES、YDLocal、JASS 与 Lua 传参、返回值和释放 | [桥接索引](bridges/README.md) |

## 阅读原则

1. 先遵守 `core/` 的全局引擎与 TSTL 硬规则。
2. 再根据具体风险进入一个或多个专项目录。
3. 联机 UI 通常需要同时读取 DzAPI 的“对称执行”和“回调安全”。
4. 桥接或调用形态改动完成后，构建并只核对相关生成 Lua。

## 最小阅读组合

| 任务 | 最小组合 |
|------|----------|
| 普通 JASS/JAPI 调用 | `core/global-engine-rules.mdc` + `core/tstl-hard-rules.mdc` |
| DzAPI 联机 UI | `dzapi/n-slot-ui-symmetric-execution.mdc` + `dzapi/lua-gc-desync-heuristics.mdc`；涉及 FDF/Frame 再读 `ui-frame-types.mdc` |
| STES/YDLocal | `bridges/stes-ydlocal-return.mdc`；涉及释放配对再读 `ydlocal-memory-release.md` |
| 随机数或 JASS 全局数组 | 读取 `tstl/` 下对应单篇，并同时遵守核心 TSTL 规则 |
