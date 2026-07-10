# War3 与 TSTL 补充规则

全仓库 TypeScriptToLua 改动仍必须先遵守 [TSTL 硬规则](../../core/tstl-hard-rules.mdc)。本目录只补充 Warcraft 3 与 Lua 语义的具体问题。

| 场景 | 读取文件 |
|------|----------|
| 读写 JASS 全局数组，或排查废弃伤害槽位 | [jass-global-array.md](jass-global-array.md) |
| 随机数、随机种子或跨客户端确定性 | [math-randomseed.md](math-randomseed.md)；新代码默认使用 JASS 随机原生 |

若改动涉及 JASS 或 JAPI 调用形态，还应回到 [全局引擎规则](../../core/global-engine-rules.mdc)。
