# STES 与 YDLocal 规则索引

此目录处理 JASS 与 Lua 的自定义事件桥接、局部变量页、传参和返回值。它同时受 TSTL 调用形态规则约束。

| 场景 | 先读 |
|------|------|
| STES 注册、YDLocal 传参、返回值、触发页或生成 Lua self 错位 | [stes-ydlocal-return.mdc](stes-ydlocal-return.mdc) |
| YDLocalInitialize 与 YDLocal1Release 配对、嵌套调用与内存释放 | [ydlocal-memory-release.md](ydlocal-memory-release.md) |

改动后先构建；再只核对相关 Lua 调用的 self、nil 与参数位置，不用泛查全部生成产物。

快速分流：事件注册、父子页传参、返回值为 0 或 self 错位看 `stes-ydlocal-return.mdc`；只涉及 `YDLocalInitialize()` / `YDLocal1Release()` 生命周期时看释放规则。
